#!/usr/bin/env ruby

require 'rubygems'
#require 'rack/handler/grizzly'
$:.unshift('../../lib') # remove this to use a local gem version
require 'rambo'

use Rack::CommonLogger
use Rack::ContentLength
app = Rambo::Server.new

run app
