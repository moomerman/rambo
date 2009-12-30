Rambo - The alternative web framework for Ruby
==============================================

Installation
------------

To install the gem:

sudo gem install rambo

Hello World Example
-------------------

Smallest example (see the hello app in the example folder)

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

Running an example locally
--------------------------

To run the Blog example:

    git clone git://github.com/moomerman/rambo.git
    cd rambo/example/blog/
    rake db:setup # check config.yml for your specific db settings
    rake server

head over to http://localhost:4000/

Features:

* No Ruby object base class modifications
* Lightweight and fast
* Rack-based so works with most web servers (thin, mongrel, passenger)
* Web applications can be deployed to Heroku
* fast static file serving
* Template agnostic
* Database agnostic
* Library only 60k
