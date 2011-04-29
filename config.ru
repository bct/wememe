require 'rubygems'
require 'bundler/setup'

this_dir = File.dirname(__FILE__)

require "#{this_dir}/rememe"

ENV['RACK_ENV'] ||= "development"

run Rememe
