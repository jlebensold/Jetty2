require 'mongoid'
require './app/models/content.rb'
ENV["RACK_ENV"] ||= 'development'

Mongoid.load!("./config/mongoid.yml")

task :dbseed do
  c = Content.new
  c.text = IO.readlines("./config/sample.txt").join()
  c.title = "Sample"
  c.version = 1
  c.save!
  puts "seed from /config/sample.txt successful"
end