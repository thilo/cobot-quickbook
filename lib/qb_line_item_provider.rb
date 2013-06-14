class QbLineItemProvider
  attr_reader :space, :qb_service

  def initialize(space, qb_service)
    @qb_service = qb_service
    @space = space
  end
  
  def get(description)
     find_line_item(description) || create_line_item(description)
  end
  
  def find_line_item(description)
    space.line_items.find_by_description(description)
  end
  
  def build_qb_object(description)
    item = Quickeebooks::Online::Model::Item.new
    item.name = description
    item.taxable =  true
    item.account_reference = Quickeebooks::Online::Model::AccountReference.new(space.qb_account_ref)
    qb_service.create(item)
  end
  
  def create_line_item(description)
    qb_object = build_qb_object(description)
    space.line_items.create!(description: description, qb_id: qb_object.id)
  end
  
end