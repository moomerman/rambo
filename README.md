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
* fast static file serving
* Template agnostic
* Database agnostic
* Library only 60k
