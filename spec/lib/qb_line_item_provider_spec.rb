require 'spec_helper'

describe QbLineItemProvider do
  describe "get" do
    let(:space) {build_stubbed :space, qb_account_ref: 1}
    let(:provider) {QbLineItemProvider.new(space, Quickeebooks::Online::Service::Item.new(oauth_stub, '1'))}

    context "line item is in database" do
      before(:each) do
        @item = LineItem.new
        space.line_items.stub(:find_by_description).with("monthly rent").and_return(@item)
      end

      it "returns a qb line item with the qb id of the line item in the database" do
        @item.qb_id = 12
        qb_line_item = provider.get("monthly rent")
        qb_line_item.qb_id.should == 12
      end
    end

    context "line item is not in database yet" do
      let (:qb_item_hash){ {name: 'monthly rent', taxable: true, income_account_ref: {account_id: 1}} }

      it "creates a new Line item in QB" do
        qb_line_item_api = stub_request(:post, /\/resource\/item\/v2\/.+/,).with(body: 
          xml_request(:item, qb_item_hash)
        ).to_return(body: 
          xml_response(:item, qb_item_hash)
        )
        provider.get("monthly rent")
        qb_line_item_api.should have_been_requested
      end
      
      it "stores the qb_id and description in the database" do
        qb_item_hash[:id] = 12
        stub_request(:post, /\/resource\/item\/v2\/.+/,).to_return(body: 
          xml_response(:item, qb_item_hash)
        )
        provider.get("monthly rent")
        space.line_items.first.qb_id.should == 12
        space.line_items.first.description.should == 'monthly rent'
        space.line_items.first.should be_persisted
      end
    end
  end
end
