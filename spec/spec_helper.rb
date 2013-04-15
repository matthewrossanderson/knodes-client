Dir[File.expand_path('../../lib/*.rb', __FILE__)].each{|f| require f}
ENV['RACK_ENV'] = 'test'
set :environment, :test

require 'rspec'
require 'rack/test'


