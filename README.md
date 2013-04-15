#Knodes Ruby Client Library

A ruby client library for the Knodes API  
See full API documentation at http://developer.kno.des/

## Usage

### Installation

Install the gem:  
```gem install knodes-client```  
or, add it to your Gemfile:  
```gem 'knodes-client'```  
```bundle install```

###Configuration
```ruby
Knodes.configure do |config| 
config.customer_id = "foo"
config.customer_secret = "bar"
end
```

###Examples

Get the customer details  
```response = Knodes.customer```

Search for a person  
```response = Knodes.people_search(:user_id=>user_id, :person_id=>"self", :q=>"Joe Schmoe")```

Get a person's details  
```response = Knodes.person(:user_id=>user_id, :person_id=>person_id)```

Search for a location  
```response = Knodes.locations_search(:user_id=>user_id, :q=>"New York")```

## Motivation

Discovered Knodes at the 2012 TechCrunch Hackathon, won the API prize for the YourQ project.  After changing the name to Que.io, we discovered that we needed a better client library, so I built it.  Gained inspiration from the client libraries for Podio and Instagram.

## Knodes API Reference

View the getting started guide here:  
http://developer.knod.es/getting_started

View the API docs here:  
http://developer.knod.es/docs

## Tests

The tests rely on sample data from your social networks.
Sign up for an account here:
https://api.knod.es/portal/signup

Then, use the test harness to get your customer data. From there you can use this client to get the rest of the sample data.  
Put your sample data into .env (sample file provided)  
Then, to run the tests, you can use Guard for autotesting, or just vanilla Rspec:

```bundle exec guard```

## Contributors

If you discover a bug or want to contribute extra functionality:

1. Fork it.
2. Create a branch (`git checkout -b feature_or_bug_branch`)
3. Commit your changes (`git commit -am "Added feature, fixed bug"`)
4. Push to the branch (`git push origin feature_or_bug_branch`)
5. Open a Pull Request
6. ...
7. Profit

## License

This client library is released under the Apache license, Version 2.0
http://www.apache.org/licenses/LICENSE-2.0.html  

Knodes and all other trademarks are © 2013 SnapGoods, Inc. All Rights Reserved.  
http://knod.es/content/tos.pdf  
http://knod.es/content/customer_agreement.pdf