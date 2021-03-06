class Invoicer
  include AuthHelpers
  def self.run
    Space.enabled.each do |space|
      begin
        Invoicer.new.run_one(space)
      rescue OAuth::Problem => e
        CobotFb.logger.info "Error in invoicer for space #{space.name}: #{e.message}"
      rescue Exception => exception
         Raven.capture_exception(exception, extra: {space: space.to_s})
      end
    end
  end

  def run_one(space, start_date = 8.days.ago.to_date, end_date = 7.days.ago.to_date)
    user =  space.user
    qb_oauth_client = qb_oauth_client(user)
    oauth_session = get_oauth_session(user.token)
    exporter = InvoiceExporter.new(space, oauth_session, qb_oauth_client)
    exporter.export(start_date, end_date)
  end
end
