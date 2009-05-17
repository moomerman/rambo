#!/usr/bin/env ruby

require 'rubygems'
$:.unshift('../../lib') # remove this to use a local gem version
require 'rambo'

use Rack::CommonLogger
use Rack::ContentLength
use Rack::Static, :urls => ["/css", "/images"], :root => "public"
use Rack::Session::Cookie, :key => 'rack.session', :secret => 'das7asd873giadugi367a6gria6g3e827etakdhnl'
app = Rambo::Server.new
run app
