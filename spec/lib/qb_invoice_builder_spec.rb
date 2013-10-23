require 'spec_helper'

describe QbInvoiceBuilder do
  describe "build" do
    let(:item_provider){stub(:provider).as_null_object}
    let(:customer_provider){stub(:provider).as_null_object}
    let(:builder){QbInvoiceBuilder.new(Quickeebooks::Online::Service::Invoice.new(oauth_stub, '1'), item_provider, customer_provider)}
    it "get the line item for the item from the provider" do
      stub_request(:post, /\/resource\/invoice\/v2\/.+/).to_return(body: xml_response(:invoice))

      item_provider.should_receive(:get).with("monthly rent")
      item_provider.should_receive(:get).with("time passes")

      builder.build(invoice_hash)
    end
    context "creates a quickbooks invoice" do
      it "with items" do
        item_provider.stub(get: LineItem.new(qb_id: 32))

        stub_request(:post, /\/resource\/invoice\/v2\/.+/).with(body:
          /#{xml_fragment(:line,
            {
              desc: 'monthly rent for August',
              amount: "80.0",
              taxable: true,
              item_id: 32,
              qty: 2.0
            }
          ) << "\n" <<
          xml_fragment(:line,
            desc: '2 time passes',
            amount: "20.0",
            taxable: true,
            item_id: 32,
            qty: 2.0
          )}/
        ).to_return(body: xml_response(:invoice))

        builder.build(invoice_hash)
      end

      it "with address data" do
        stub_request(:post, /\/resource\/invoice\/v2\/.+/).with(body:
          /#{xml_fragment(:bill_addr,
            line1: 'joe inc.',
            line2: 'joe doe',
            line3: '1 broadway',
            city: 'atlantis',
            country: 'ocean',
            country_sub_division_code: 'AT',
            postal_code: '94153',
          )}/
        ).to_return(body: xml_response(:invoice))

        builder.build(invoice_hash)
      end

    end


    it "returns the quickbooks invoice object" do
      stub_request(:post, /\/resource\/invoice\/v2\/.+/).to_return(body: xml_response(:invoice, {id: 23}))

      builder.build(invoice_hash).id.to_i.should == 23
    end

  end

  def invoice_hash
    #taken from cobot api doc
    {
      "created_at" => "2012-01-01",
      "currency" => "EUR",
      "id" => "cc7e75473a6911587b63d78f4e3f8eba",
      "membership_id" => "a9f6bcbed420c37539fa1257e66fd66b",
      "address" => {
          "name" => "joe doe",
          "address" => "1 broadway",
          "company" => "joe inc.",
          "post_code" => "94153",
          "city" => "atlantis",
          "country" => "ocean",
          "state" => "AT"
      },
      "space_address" => {
          "name" => "john space",
          "address" => "2 coworking way",
          "company" => "space inc.",
          "post_code" => "37521",
          "city" => "new atlantis",
          "country" => "oceanis",
          "state" => "AL"

      },
      "invoice_text" => "pay now",
      "tax_rate" => "20.0",
      "invoice_number" => 100,
      "items" => [
      {
          "amount" => "80.0",
          "description" => "monthly rent for August",
          "quantity" => "2.0",
          "tax_rate" => "20.0",
          "tag" => "membership",
          "tag_name" => "monthly rent"

      },
      {
          "amount" => "20.0",
          "description" => "2 time passes",
          "quantity" => "2.0",
          "tax_rate" => "20.0",
          "tag" => "passes",
          "tag_name" => "time passes"
      }
      ],
      "total_amount" => "240.0",
      "total_amount_without_taxes" => "200.0",
      "tax_amounts" => {"20.0" => "40.0"},
      "url" => "http://some-space.cobot.me/api/invoices/100",
      "paid" => false
    }.with_indifferent_access
  end
end
