desc "Task for exporting to quickbooks run by the heroku scheduler"
task :export_to_quickbooks => :environment do
  puts "Starting imports"
  Invoicer.run
  puts "done."
end

desc "Ping the app it self to keep awake"
task :keep_awake do
 require 'net/http'
 Net::HTTP.get(URI('http://cobot-quickbook.herokuapp.com/'))
end