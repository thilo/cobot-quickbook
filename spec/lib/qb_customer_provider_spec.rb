require 'spec_helper'

describe QbCustomerProvider do
  describe "get" do
    let(:space) {build_stubbed :space, qb_account_ref: 1}
    let(:provider) {QbCustomerProvider.new(space, Quickeebooks::Online::Service::Customer.new(oauth_stub, '1'))}

    context "customer is in database" do
      before(:each) do
        @customer = Customer.new
        space.customers.stub(find_by_name: @customer)
      end

      it "returns a customer for the qb_id" do
        @customer.qb_id = 12
        customer = provider.get({name: 'joe doe'})
        customer.should == @customer
      end
    end

    context "customer is not in database yet" do
      let (:qb_customer_hash) do {name: 'joe doe',
        address: {
          line1: 'joe doe',
          line2: 'joe inc.',
          line3: '1 broadway',
          city: 'atlantis',
          country: 'ocean',
          country_sub_division_code: 'AT',
          postal_code: '94153'
        }}
      end

      it "creates a new customer in QB" do
        qb_customer_api = stub_request(:post, /\/resource\/customer\/v2\/.+/,).with(body:
          xml_request(:customer, qb_customer_hash)
        ).to_return(body:
          xml_response(:customer, qb_customer_hash)
        )

        provider.get(name: "joe doe",
              address: "1 broadway",
              company: "joe inc.",
              post_code: "94153",
              city: "atlantis",
              country: "ocean",
              state: "AT")

        qb_customer_api.should have_been_requested
      end

      it "uses the company name as customer name if no name in address" do
        qb_customer_api = stub_request(:post, /\/resource\/customer\/v2\/.+/,).with(body:
          %r{<Name>joe inc\.</Name>}
        ).to_return(body:
          xml_response(:customer, qb_customer_hash)
        )
        provider.get(name: "",
              address: "1 broadway",
              company: "joe inc.",
              post_code: "94153",
              city: "atlantis",
              country: "ocean",
              state: "AT")

        qb_customer_api.should have_been_requested
      end

      it "stores the qb_id and name in the db" do
        qb_customer_hash[:id] = 13
        stub_request(:post, /\/resource\/customer\/v2\/.+/,).to_return(body:
          xml_response(:customer, qb_customer_hash)
        )

        provider.get({name: 'stub_hash'})

        customer = space.customers.first
        customer.qb_id.should == 13
        customer.name.should == 'stub_hash'
        customer.should be_persisted
      end
    end
  end
end
