require 'rubygems'
$:.unshift('../../lib') # remove this to use a local gem version
require 'rambo'
Rambo::Env.new # makes sure we have all required dependencies

task :default do
  puts 'rake db:setup          to create the initial schema'
  puts 'rake server            to run the web server'
end

task :server do
  exec "thin start -R server.ru -p 3000 --threaded"
end

namespace :db do
  task :setup do
    DataMapper.auto_migrate!
  end
  
  task :migrate do
    DataMapper.auto_upgrade!
  end
end