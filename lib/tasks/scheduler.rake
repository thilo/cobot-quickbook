desc "Task for exporting the Heroku scheduler add-on"
task :import_from_quickbook => :environment do
  puts "Starting imports"
  Invoicer.run
  puts "done."
end