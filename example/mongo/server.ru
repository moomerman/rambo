#!/usr/bin/env ruby

require 'rubygems'
$:.unshift('../../lib') # remove this to use a local gem version
require 'rambo'

use Rack::CommonLogger
use Rack::ContentLength
use Rack::Static, :urls => ["/css", "/images", "/js"], :root => "public"
app = Rambo::Server.new
run app
