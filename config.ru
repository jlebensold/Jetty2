require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'coffee-script'
require './bootstrap'

set :environment, :development
set :run, false

require 'mongoid'
require 'mongoid-ancestry'
require './app/models/content.rb'
require './app/models/note.rb'
require './app/models/authority.rb'
ENV["RACK_ENV"] ||= 'development'

Mongoid.load!("./config/mongoid.yml")


run Bootstrap::Application.new