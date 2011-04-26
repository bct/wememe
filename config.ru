require 'rubygems'
require 'bundler/setup'

this_dir = File.dirname(__FILE__)

require "#{this_dir}/rememe"

ENV['RACK_ENV'] ||= "development"

rack_env = ENV['RACK_ENV']

unless rack_env == "production"
  config = YAML.load_file(File.join("#{this_dir}/config.yml"))[rack_env]

  config.each do |key, value|
    ENV[key] = value
  end
else
  require 'exceptional'
  use Rack::Exceptional, ENV['EXCEPTIONAL_KEY']
end

run Rememe
