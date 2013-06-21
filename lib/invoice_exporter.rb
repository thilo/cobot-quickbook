class InvoiceExporter
  def initialize(space, cobot_oauth, qb_oauth)
    realm_id = space.user.qb_realm_id
    qb_line_item_service = Quickeebooks::Online::Service::Item.new(qb_oauth, realm_id)
    qb_inv_service = Quickeebooks::Online::Service::Invoice.new(qb_oauth, realm_id)
    qb_customer_service = Quickeebooks::Online::Service::Customer.new(qb_oauth, realm_id)
    line_item_provider =  QbLineItemProvider.new(space, qb_line_item_service)
    customer_provider =  QbCustomerProvider.new(space, qb_customer_service)
    @invoice_builder = QbInvoiceBuilder.new(qb_inv_service, line_item_provider, customer_provider)
    @space = space
    @cobot_oauth = cobot_oauth
  end

  def export(start_date, end_date)
    invoices_json = get_cobot_invoices(start_date, end_date)
    create_qb_invoices(invoices_json)
  end
  private

  def get_cobot_invoices(start_date, end_date)
    url = "https://#{@space.cobot_id}.cobot.me/api/invoices?from=#{start_date.to_s}&to=#{end_date.to_s}&tags=true"
    JSON.parse(@cobot_oauth.get(url).body, symbolize_names: true)
  end
  
  def create_qb_invoices(invoices_json)
    invoices_json.each do |inv|
      @space.invoices.create!(qb_id: @invoice_builder.build(inv).id, cobot_id: inv[:id]) unless @space.invoices.first(cobot_id: inv[:id])
    end
  end
end