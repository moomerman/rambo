#!/usr/bin/env ruby

require 'rubygems'
$:.unshift('../../lib') # remove this to use a local gem version
require 'rambo'

#use Rack::CommonLogger
use Rack::ContentLength
use Rack::Static, :urls => ["/css", "/images", '/javascript'], :root => "public"
use Rack::Session::Cookie, :key => 'rack.session', :secret => 'abcdefg'
app = Rambo::Server.new
run app
