require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/*_spec.rb'
  spec.rspec_opts = ['--format documentation', '--colour']
end

namespace :db do
  desc "Wipe and recreate the database."
  task :automigrate do
    require_relative 'rememe'
    DataMapper.auto_migrate!
  end
end

task :default => [:spec]
