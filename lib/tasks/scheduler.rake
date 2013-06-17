desc "Task for exporting the Heroku scheduler add-on"
task :export_to_quickbooks => :environment do
  puts "Starting imports"
  Invoicer.run
  puts "done."
end