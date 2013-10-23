require 'spec_helper'

describe QbCustomerProvider do
  describe "get" do
    let(:space) {build_stubbed :space, qb_account_ref: 1}
    let(:provider) {QbCustomerProvider.new(space, Quickeebooks::Online::Service::Customer.new(oauth_stub, '1'))}

    context "customer is in database" do
      let(:qb_customer_hash) do {
        id: 34,
        name: 'joe doe',
        address: {
          line1: 'joe inc.',
          line2: 'joe doe',
          line3: '1 broadway',
          city: 'atlantis',
          country: 'ocean',
          country_sub_division_code: 'AT',
          postal_code: '94153'
        }}
      end

      let!(:get_qb_customer_api){stub_request(:get, /\/resource\/customer\/v2\/1\/34/).to_return(
        body: xml_response(:customer, qb_customer_hash)
      )}

      let!(:update_qb_customer_api){stub_request(:post, /\/resource\/customer\/v2\/1\/34/).to_return(
        body: xml_response(:customer, qb_customer_hash)
      )}

      before(:each) do
        @customer = Customer.new(qb_id: 34)
        space.customers.stub(find_by_cobot_membership_id: @customer)

      end

      it "returns a customer for the qb_id" do
        @customer.qb_id = 34
        customer = provider.get('123', {name: 'joe doe'})
        customer.should == @customer
      end

      it "gets the customer form QB" do
        customer = provider.get('123', {name: 'joe doe'})
        get_qb_customer_api.should have_been_requested
      end

      it "updates the customer on QB" do
        customer = provider.get('123', {name: 'joe doe'})
        update_qb_customer_api.should have_been_requested
      end
    end

    context "customer is not in database yet" do
      let(:qb_customer_hash) do {
        name: 'joe doe',
        address: {
          line1: 'joe inc.',
          line2: 'joe doe',
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

        provider.get('123', name: "joe doe",
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
        provider.get('test', name: "",
              address: "1 broadway",
              company: "joe inc.",
              post_code: "94153",
              city: "atlantis",
              country: "ocean",
              state: "AT")

        qb_customer_api.should have_been_requested
      end

      it "stores the cobot_id, qb_id and name in the db" do
        qb_customer_hash[:id] = 13
        stub_request(:post, /\/resource\/customer\/v2\/.+/,).to_return(body:
          xml_response(:customer, qb_customer_hash)
        )

        provider.get('cobot_id', {name: 'stub_hash'})

        customer = space.customers.first
        customer.qb_id.should == 13
        customer.name.should == 'stub_hash'
        customer.cobot_id.should == 'cobot_id'
        customer.should be_persisted
      end
    end
  end
end
