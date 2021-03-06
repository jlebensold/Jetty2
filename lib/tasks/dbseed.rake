require 'mongoid'
require 'mongoid-ancestry'
require './app/models/content.rb'
require './app/models/note.rb'
require './app/models/authority.rb'
ENV["RACK_ENV"] ||= 'development'

Mongoid.load!("./config/mongoid.yml")

task :dbseed do

  Content.destroy_all()
  Note.destroy_all()
  Authority.destroy_all()
  c = Content.new
  c.text = IO.readlines("./config/sample.txt").join()
  c.title = "Sample"
  c.version = 1
  c.save!



  n = Note.new
  n.version = 1
  n.start_paragraph = 1
  n.end_paragraph = 1
  n.start_paragraph_char = 4
  n.end_paragraph_char = 34
  n.content = c
  n.text = "hello world!"
  n.save!

  puts "seed from /config/sample.txt successful"



  a = Authority.new({name: "root"})
  a.save()

  b = Authority.new({name: "childa"})
  b.parent = a
  b.save()

  ba = Authority.new({name: "childb"})
  ba.parent = a
  ba.save()

end
