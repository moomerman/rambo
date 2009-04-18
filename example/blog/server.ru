#!/usr/bin/env ruby

require 'rubygems'
require 'rack/cache'
$:.unshift('../../lib') # remove this to use a local gem version
require 'rambo'

use Rack::CommonLogger
use Rack::ContentLength
use Rack::Upload
use Rack::Cache,
   :verbose     => false,
   :metastore   => 'heap:/',
   :entitystore => 'heap:/',
   :allow_reload => false
use Rack::Static, :urls => ["/css", "/images"], :root => "public"

use Rack::Session::Cookie, :key => 'rack.session',
                             :expire_after => 2592000,
                             :secret => 'abcdefg'
  
#use Rack::Proxy, :backend => [4001, 4002]

use Rack::Lock
app = Rambo::Server.new
run app
