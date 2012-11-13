# Knodes Ruby Client Library

This is a client written for the knod.es API

## Getting started using the library

1. Install the gem
2. Include it in your project.
3. Configure it
	With a block:
		Knodes.configure do |config|
			config.customer_id = "foo"
			config.customer_secret = "bar"
		end
	With arguments:
		c = Knodes.client(:customer_id=>"foo", :customer_secret=>"bar")
4. Make some calls
	Knodes.customer
	Knodes.user(:user_id=>"baz")
5. Improve the library
	I've implemented all of the calls in the documentation for knodes, but as this is the first proper api client I've written, I welcome any and all feedback.  Submit pull requests for any code changes, thanks!


## Knodes Documentation
http://developer.knod.es

		


