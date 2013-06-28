require 'mongoid'
require 'mongoid-ancestry'
require './app/models/content.rb'
require './app/models/note.rb'
require './app/models/authority.rb'
require 'pp'
ENV["RACK_ENV"] ||= 'development'

Mongoid.load!("./config/mongoid.yml")

task :ingest_pdf, [:file] do |t, args|
  
end

task :ingest, [:file] do |t,args|
  txt = IO.readlines(File.expand_path(args[:file])).join("")
  c = Content.create(:title => File.basename(args[:file]), 
                     :version => 1, 
                     :text => txt)
end
