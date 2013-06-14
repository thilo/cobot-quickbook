##
# You can use other adapters like:
#
#   ActiveRecord::Base.configurations[:development] = {
#     :adapter   => 'mysql',
#     :encoding  => 'utf8',
#     :reconnect => true,
#     :database  => 'your_database',
#     :pool      => 5,
#     :username  => 'root',
#     :password  => '',
#     :host      => 'localhost',
#     :socket    => '/tmp/mysql.sock'
#   }
#
postgres = URI.parse(ENV['DATABASE_URL'] || '')

ActiveRecord::Base.configurations[:production] = {
  :adapter  => 'postgresql',
  :encoding => 'utf8',
  :database => postgres.path[1..-1], 
  :username => postgres.user,
  :password => postgres.password,
  :host     => postgres.host
}

ActiveRecord::Base.configurations[:development] = {
  :adapter  => 'postgresql',
  :encoding => 'utf8',
  :database => 'cobot_quickbook_development'

}


ActiveRecord::Base.configurations[:test] = {
  :adapter  => 'postgresql',
  :encoding => 'utf8',
  :database => 'cobot_quickbook_test'
}

# Setup our logger
ActiveRecord::Base.logger = logger

# Include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = false

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper.
# if you're including raw json in an HTML page.
ActiveSupport.escape_html_entities_in_json = false

# Now we can estabilish connection with our db
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[Padrino.env])
