#!/usr/bin/env ruby

require 'rubygems'
require 'rambo'

use Rack::CommonLogger
#use Rack::ContentLength
use Rack::Lock
app = Rambo::Server.new
run app
