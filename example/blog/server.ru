#!/usr/bin/env ruby

require 'rubygems'
require 'rack/cache'
require 'rambo'

use Rack::CommonLogger
use Rack::ContentLength
use Rack::Static, :urls => ["/css", "/images"], :root => "public"
use Rack::Upload
use Rack::Cache,
   :verbose     => false,
   :metastore   => 'heap:/',
   :entitystore => 'heap:/',
   :allow_reload => false

use Rack::Session::Cookie, :key => 'rack.session',
                             :domain => 'foo.com',
                             :path => '/',
                             :expire_after => 2592000,
                             :secret => 'abcdefg'
  
#use Rack::Proxy, :backend => [4001, 4002]

use Rack::Lock
app = Rambo::Server.new
run app
