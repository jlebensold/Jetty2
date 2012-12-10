require 'rubygems'
require 'net/pop'

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

require 'daemons'
 
options = {
  :app_name   => "jetty_bot",
  :ARGV       => [ARGV[0], "--", "jetty_bot"],
  :dir_mode   => :normal,
  :dir        => './pid',
  :backtrace  => true,
  :log_output => true,
  :monitor    => true
}

Daemons.run('./lib/bot.rb',options)

