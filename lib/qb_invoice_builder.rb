class QbInvoiceBuilder

  def initialize(qb_service, line_item_provider, customer_provider)
    @qb_service = qb_service
    @line_item_provider = line_item_provider
    @customer_provider = customer_provider
  end

  def build(inv)
    qb_invoice = Quickeebooks::Online::Model::Invoice.new
    header = qb_invoice.header = Quickeebooks::Online::Model::InvoiceHeader.new
    customer = @customer_provider.get(inv[:membership_id], inv[:address])
    # invoice number
    header.doc_number = inv[:invoice_number]
    header.customer_id = Quickeebooks::Online::Model::Id.new(customer.qb_id)

    recipent = header.billing_address = Quickeebooks::Online::Model::Address.new
    recipent.line1 = inv[:address][:name]
    recipent.line2 = inv[:address][:company]
    recipent.line3 = inv[:address][:address]
    recipent.city = inv[:address][:city]
    recipent.postal_code = inv[:address][:post_code]
    recipent.country_sub_division_code = inv[:address][:state]
    recipent.country = inv[:address][:country]

    header.tax_amount = inv[:tax_amounts].values.first #QB only supports one tax rate
    header.total_amount = inv[:total_amount]
    header.sub_total_amount = inv[:total_amount_without_taxes]

    inv[:items].each do |item|
       line_item = Quickeebooks::Online::Model::InvoiceLineItem.new
       line_item.item_id = Quickeebooks::Online::Model::Id.new(@line_item_provider.get(item[:tag_name]).qb_id)
       line_item.desc = item[:tag_name]
       line_item.taxable = item[:tax_rate].to_f > 0
       line_item.amount = item[:amount]
       line_item.quantity = item[:quantity]
       qb_invoice.line_items << line_item
     end
    @qb_service.create(qb_invoice)
  end
end