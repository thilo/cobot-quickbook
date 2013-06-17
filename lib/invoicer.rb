class Invoicer
  include AuthHelpers
  def self.run
    Space.all.each do |space|
      Invoicer.new.run_one(space)
    end
  end
  
  def run_one(space)
    user =  space.user
    qb_oauth_client = qb_oauth_client(user)
    oauth_session = get_oauth_session(user.token)
    exporter = InvoiceExporter.new(space, oauth_session, qb_oauth_client)
    exporter.run(Date.today.beginning_of_month, Date.today.end_of_month)
  end
end