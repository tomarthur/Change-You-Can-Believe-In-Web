require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-timestamps'

Bundler.require

require './app.rb'
run Sinatra::Application
