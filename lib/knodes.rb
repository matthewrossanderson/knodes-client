require 'faraday'
require 'faraday_middleware'
require 'hashie'

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

  extend Configuration

  module Connection
  	def connection(raw=false)
  		options = {
        :headers => {'Accept' => "application/#{format}; charset=utf-8", 'User-Agent' => user_agent},
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => endpoint,
      }

  		Faraday::Connection.new(options) do |connection|
        connection.use FaradayMiddleware::Mashify unless raw
        connection.use Faraday::Request::UrlEncoded
        connection.use Faraday::Response::RaiseError
        unless raw
          case format.to_s.downcase
          when 'json' then connection.use Faraday::Response::ParseJson
          end
        end
        #Todo: Implement HTTP Exceptions
        #connection.use FaradayMiddleware::RaiseHttpException
        connection.adapter(adapter)
  		end
  	end
  end

  module Request
    # Perform an HTTP GET request
    def get(path, options={}, raw=false, unformatted=false, debug=false)
      request(:get, path, options, raw, unformatted, debug)
    end

    # Perform an HTTP POST request
    def post(path, options={}, raw=false, unformatted=false, debug=false)
      request(:post, path, options, raw, unformatted, debug)
    end

    # Perform an HTTP PUT request
    def put(path, options={}, raw=false, unformatted=false, debug=false)
      request(:put, path, options, raw, unformatted, debug)
    end

    # Perform an HTTP DELETE request
    def delete(path, options={}, raw=false, unformatted=false, debug=false)
      request(:delete, path, options, raw, unformatted, debug)
    end

    private

    # Perform an HTTP request
    def request(method, path, options, raw=false, unformatted=false, debug=false)
      response = connection(raw).send(method) do |request|
        path = formatted_path(path) unless unformatted
        case method
        when :get, :delete
          request.url(path, options)
        when :post, :put
          request.path = path
          request.body = options unless options.empty?
        end

        puts request.inspect if debug
      end
      raw ? response : response.body
    end

    def formatted_path(path)
      [path, format].compact.join('.')
    end
  end

	class Client  

    # Creates a new client and sets configuration to passed options or their default values
    def initialize(options={}) 
      options = Knodes.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    #convenience method for returning id/secret
    def creds
      Hash["customer_id" => customer_id, "customer_secret" => customer_secret]
    end


    #here comes the good stuff.  modules separated by Knodes resources, with methods for each api call
    module Customers
    	def customer
    		response = get("customers", creds)
   		end

      def customer_connect(options={})
        response = post("customers/#{options[:customer_id]}/connect", options = options.merge(creds))
      end

      def customer_disconnect(options={})
        response = post("customers/#{options[:customer_id]}/disconnect", options = options.merge(creds))
      end
    end

    module Users
  		def user(options={})
  			response = get("users/#{options[:user_id]}", options.merge(creds))
    	end

      def user_connect(options={})
        response = post("users/connect", options.merge(creds))
      end

      def user_disconnect(options={})
        response = post("users/disconnect", options.merge(creds))
      end

      def notify_active(options={})
        response = post("users/notify_active", options.merge(creds))
      end

      def notify_inactive(options={})
        #do a raw request/response (don't parse), as this method only returns an http status
        response = post("users/notify_inactive", options.merge(creds), true)
        status = response.env[:status]
      end

      def ready(options={})
        response = get("users/#{options[:user_id]}/ready", options.merge(creds), true)
        body = response.env[:body]
      end

      def do_index(options={})
        response = post("users/#{options[:user_id]}/do_index", options.merge(creds), true)
        status = response.env[:status]
      end
    end

    module People
      def person(options={})
        response = get("people/#{options[:person_id]}", options.merge(creds))
      end

      def people_search(options={})
        options.merge!({ :type=> "people" })
        response = get("people/search", options.merge(creds))
      end

      def person_people(options={})
        options.merge!({:type=>"people", :q=>""})
        response = get("search", options.merge(creds))
      end

      def person_documents(options={})
        response = get("people/#{options[:person_id]}/documents", options.merge(creds))
      end

      def person_locations(options={})
        response = get("people/#{options[:person_id]}/locations", options.merge(creds))
      end

      def person_companies(options={})
        response = get("people/#{options[:person_id]}/documents", options.merge(creds))
      end

      def person_schools(options={})
        response = get("people/#{options[:person_id]}/documents", options.merge(creds))
      end
    end

    module Documents
      def document(options={})
        response = get("documents/#{options[:doc_id]}", options.merge(creds))
      end

      def documents_search(options={})
        response = get("documents/search", options.merge(creds))
      end

      def document_people(options={})
        response = get("documents/#{options[:doc_id]}/people", options.merge(creds))
      end

      def document_locations(options={})
        response = get("documents/#{options[:doc_id]}/locations", options.merge(creds))
      end
    end

    module Locations
      def location(options={})
        response = get("locations/#{options[:location_id]}", options.merge(creds))
      end

      def locations_search(options={})
        response = get("locations/search", options.merge(creds))
      end

      def location_people(options={})
        response = get("locations/#{options[:location_id]}/people", options.merge(creds))
      end

      def location_documents(options={})
        response = get("locations/#{options[:location_id]}/documents", options.merge(creds))
      end
    end

    module Companies
      def company(options={})
        response = get("companies/#{options[:company_id]}", options.merge(creds))
      end

      def companies_search(options={})
        response = get("companies/search", options.merge(creds))
      end

      def company_people(options={})
        response = get("companies/#{options[:company_id]}/people", options.merge(creds))
      end
    end

    module Schools
      def school(options={})
        response = get("schools/#{options[:school_id]}", options.merge(creds))
      end

      def schools_search(options={})
        response = get("schools/search", options.merge(creds))
      end

      def school_people(options={})
        response = get("schools/#{options[:school_id]}/people", options.merge(creds))
      end
    end

    include Connection
    include Request
    include Customers
    include Users
    include People
    include Documents
    include Locations
    include Companies
    include Schools
  end 	

  #Knodes module methods
  
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