module Knodes
  module Configuration
    VALID_OPTIONS_KEYS = [
      :customer_id,
      :customer_secret,
      :endpoint,
      :adapter,
      :format,
      :proxy,
      :user_agent
    ].freeze

    attr_accessor *VALID_OPTIONS_KEYS

    ##DEFAULT CONSTANTS##

    # The adapter that will be used to connect if none is set
    # The default faraday adapter is Net::HTTP.
    DEFAULT_ADAPTER = Faraday.default_adapter

    # By default, don't set a customer ID
    DEFAULT_CUSTOMER_ID = nil

    # By default, don't set a customer secret
    DEFAULT_CUSTOMER_SECRET = nil

    # The endpoint that will be used to connect if none is set
    DEFAULT_ENDPOINT = 'https://api.knod.es/'

    # By default, don't use a proxy server
    DEFAULT_PROXY = nil

    # The response format appended to the path and sent in the 'Accept' header if none is set
    # JSON is the only available format at this time
    DEFAULT_FORMAT = :json

    # The user agent that will be sent to the API endpoint if none is set
    DEFAULT_USER_AGENT = 'KnodesRubyClient/1.0'

    #allow config values to be set in a block
    def configure
      yield self
    end

    #return hash of options
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    def reset
      self.adapter         = DEFAULT_ADAPTER
      self.customer_id     = DEFAULT_CUSTOMER_ID
      self.customer_secret = DEFAULT_CUSTOMER_SECRET
      self.endpoint        = DEFAULT_ENDPOINT
      self.format          = DEFAULT_FORMAT
      self.proxy           = DEFAULT_PROXY
      self.user_agent      = DEFAULT_USER_AGENT
     end
  end
end