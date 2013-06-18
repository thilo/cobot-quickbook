class QbCustomerProvider
  attr_reader :space, :qb_service

  def initialize(space, qb_service)
    @qb_service = qb_service
    @space = space
  end

  def get(membership_id, customer_hash)
     find_customer(membership_id) || create_customer(membership_id, customer_hash)
  end

private

  def find_customer(membership_id)
    space.customers.find_by_cobot_id(membership_id)
  end

  def build_qb_object(customer_hash)
    customer = Quickeebooks::Online::Model::Customer.new
    address = customer.address = Quickeebooks::Online::Model::Address.new
    customer.name = customer_name(customer_hash)
    address.line1 = customer_hash[:name]
    address.line2 = customer_hash[:company]
    address.line3 = customer_hash[:address]
    address.city = customer_hash[:city]
    address.postal_code = customer_hash[:post_code]
    address.country_sub_division_code = customer_hash[:state]
    address.country = customer_hash[:country]
    qb_service.create(customer)
  end

  def customer_name(customer_hash)
    customer_hash[:name].blank? ? customer_hash[:company] : customer_hash[:name]
  end

  def create_customer(membership_id, customer_hash)
    qb_object = build_qb_object(customer_hash)
    space.customers.create!(cobot_id: membership_id, qb_id: qb_object.id)
  end

end