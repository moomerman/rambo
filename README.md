Rambo - The alternative web framework for Ruby
==============================================

Installation
------------

To install the gem:

sudo gem install rambo

Hello World Example
-------------------

Smallest example, create a file called HomeController.rb with:

    class HomeController < Rambo::Controller
      def index
        "hello world"
      end
    end

Now create a config.ru file to tell rack how to run the application eg:

    #!/usr/bin/env ruby

    require 'rubygems'
    require 'rambo'

    app = Rambo::Server.new

    run app
    
Now you can run it with your favourite rack-based server, eg:

    thin start -R config.ru

Creating a new application
--------------------------

Use the rambo executable to create a new skeleton application:

    rambo blog

This should generate the minimal skeleton like this:

    Generating application blog ...
    creating blog/
    creating blog/controller/BlogController.rb
    creating blog/view/index.erb
    creating blog/view/layout.erb
    creating blog/rambo.yml
    creating blog/config.ru
    
Run the example using:

    rackup

Head over to:

    http://localhost:9292/

Features
--------

* No Ruby object base class modifications
* Lightweight and fast
* Rack-based so works with most web servers (thin, mongrel, passenger)
* Web applications can be deployed to Heroku
* fast static file serving
* Template agnostic
* Database agnostic
* Library only 60k
