require 'spec_helper'

describe InvoiceExporter do
  before(:each) do
    @qb_inv_builder_stub = stub(:qb_inv_builder_stub).as_null_object
    QbInvoiceBuilder.stub(:new => @qb_inv_builder_stub)
  end
  let(:space){build_stubbed :space, cobot_id: "co-up", user: build_stubbed(:user, qb_realm_id: 12)}
  let(:exporter){InvoiceExporter.new(space, oauth2_stub ,oauth_stub)}
  describe "export" do

    it "requests invoices for the time frame from cobot api" do
      cobot_api = stub_request(:get, 'https://co-up.cobot.me/api/invoices').with(:query =>  hash_including({from: '2013-02-01', to: '2013-02-28'})).to_return(body: '[]')
      exporter.export(Date.parse('2013-02-01'), Date.parse('2013-02-28'))
      cobot_api.should have_been_requested
    end

    it "stores references to each exported invoice" do
      stub_request(:get, %r{https://co-up.cobot.me/api/invoices}).to_return(body: '[{"id": "cobot_inv_id"}]')
      @qb_inv_builder_stub.stub(:build => stub(:qb_inv, id: 123))

      exporter.export(Date.parse('2013-02-01'), Date.parse('2013-02-28'))

      new_invoice =  space.invoices.first
      new_invoice.cobot_id.should == "cobot_inv_id"
      new_invoice.qb_id.should == 123
    end

    it "does not generate existing invoices again" do
      stub_request(:get, %r{https://co-up.cobot.me/api/invoices}).to_return(body: '[{"id": "cobot_inv_id"}]')
      space.stub_chain(:invoices, :where, first: Invoice.new(cobot_id: "cobot_inv_id"))

      @qb_inv_builder_stub.should_not_receive(:build)

      exporter.export(Date.parse('2013-02-01'), Date.parse('2013-02-28'))
    end
  end
end
