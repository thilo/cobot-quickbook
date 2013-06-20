class Invoicer
  include AuthHelpers
  def self.run
    Space.all.each do |space|
      Invoicer.new.run_one(space)
    end
  end
  
  def run_one(space, start_date = Date.yesterday, end_date = Date.today)
    user =  space.user
    qb_oauth_client = qb_oauth_client(user)
    oauth_session = get_oauth_session(user.token)
    exporter = InvoiceExporter.new(space, oauth_session, qb_oauth_client)
    exporter.export(start_date, end_date)
  end
end