#!/usr/bin/env ruby

require 'rubygems'
$:.unshift('../../lib') # remove this to use a local gem version
require 'rambo'

use Rack::CommonLogger
use Rack::ContentLength
use Rack::Static, :urls => ["/css", "/images", "/js"], :root => "public"
use Rack::Session::Cookie, :key => 'rack.session', :secret => '7B5D6ECA-E895-46F5-A09D-B2F960C07E77'
app = Rambo::Server.new
run app
