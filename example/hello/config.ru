#!/usr/bin/env ruby

require 'rubygems'
# $:.unshift('../../lib') # use this for testing
require 'rambo'

use Rack::CommonLogger
use Rack::ContentLength
app = Rambo::Server.new

run app
