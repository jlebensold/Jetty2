require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'coffee-script'
require './bootstrap'

set :environment, :development
set :run, false

require 'mongoid'
require './app/models/content.rb'
require './app/models/note.rb'
ENV["RACK_ENV"] ||= 'development'

Mongoid.load!("./config/mongoid.yml")


run Bootstrap::Application.new