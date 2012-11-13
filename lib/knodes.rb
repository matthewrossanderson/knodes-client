require 'faraday'
require 'faraday_middleware'

require File.expand_path('../knodes/configuration', __FILE__)
require File.expand_path('../knodes/connection', __FILE__)
require File.expand_path('../knodes/request', __FILE__)
require File.expand_path('../knodes/client', __FILE__)

module Knodes
  extend Configuration

  #Knodes module methods#
  
  # Alias for Knodes::Client.new
  def self.client(options={})
    Knodes::Client.new(options)
  end

  # Delegate to Knodes::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Knodes::Client
  def self.respond_to?(method)
    return client.respond_to?(method) || super
  end
end