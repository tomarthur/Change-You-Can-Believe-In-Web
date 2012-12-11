require 'rubygems'
require 'sinatra'

Bundler.require

require './app.rb'
run Sinatra::Application
