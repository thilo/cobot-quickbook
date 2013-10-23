class QbCustomerProvider
  attr_reader :space, :qb_service

  def initialize(space, qb_service)
    @qb_service = qb_service
    @space = space
  end

  def get(cobot_membership_id, customer_hash)
     find_and_update_customer(cobot_membership_id, customer_hash) || create_customer(cobot_membership_id, customer_hash)
  end

private

  def find_and_update_customer(cobot_membership_id, customer_hash)
    customer = find_customer(cobot_membership_id) || legacy_find_customer(cobot_membership_id, customer_hash)
    if customer
      qb_customer = qb_service.fetch_by_id(customer.qb_id)
      update_customer(qb_customer, customer_hash)
    end
    customer
  end

  def find_customer(cobot_membership_id)
    space.customers.find_by_cobot_membership_id(cobot_membership_id)
  end

  def legacy_find_customer(cobot_membership_id, customer_hash)
    customer = space.customers.find_by_name(customer_name(customer_hash))
    customer.update_attribute(:cobot_membership_id, cobot_membership_id) if customer
    customer
  end

  def build_qb_customer(customer_hash, qb_customer = Quickeebooks::Online::Model::Customer.new)
    logger.info 'buidling customer from ' << customer_hash.to_s
    qb_customer.address = build_qb_address(customer_hash)
    qb_customer.name = customer_name(customer_hash)
    qb_customer
  end

  def build_qb_address(customer_hash)
    qb_address = Quickeebooks::Online::Model::Address.new
    qb_address.line1 = customer_hash[:company]
    qb_address.line2 = customer_hash[:name]
    qb_address.line3 = customer_hash[:address]
    qb_address.city = customer_hash[:city]
    qb_address.postal_code = customer_hash[:post_code]
    qb_address.country_sub_division_code = customer_hash[:state]
    qb_address.country = customer_hash[:country]
    qb_address
  end

  def customer_name(customer_hash)
    customer_hash[:name].blank? ? customer_hash[:company] : customer_hash[:name]
  end

  def create_customer(cobot_membership_id, customer_hash)
    logger.info 'exporting customer from ' << customer_hash.to_s
    qb_customer = build_qb_customer(customer_hash)
    qb_object = qb_service.create(qb_customer)
    space.customers.create!(name: customer_name(customer_hash), qb_id: qb_object.id, cobot_membership_id: cobot_membership_id)
  end

  def update_customer(qb_customer, customer_hash)
    logger.info 'export customer update from ' << customer_hash.to_s
    qb_customer = build_qb_customer(customer_hash, qb_customer)
    qb_service.update(qb_customer)
  end

end