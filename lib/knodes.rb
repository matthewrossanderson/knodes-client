require 'faraday'
require 'faraday_middleware'
require 'hashie'

module Knodes

  module Connection
  	def connection(raw=false)
  		options = {
        :headers => {'Accept' => "application/#{format}; charset=utf-8", 'User-Agent' => user_agent},
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => endpoint,
      }

  		Faraday::Connection.new(options) do |connection|
        connection.use Faraday::Request::UrlEncoded
        connection.use FaradayMiddleware::Mashify unless raw
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
    def get(path, options={}, raw=false, unformatted=false)
      request(:get, path, options, raw, unformatted)
    end

    # Perform an HTTP POST request
    def post(path, options={}, raw=false, unformatted=false)
      request(:post, path, options, raw, unformatted)
    end

    # Perform an HTTP PUT request
    def put(path, options={}, raw=false, unformatted=false)
      request(:put, path, options, raw, unformatted)
    end

    # Perform an HTTP DELETE request
    def delete(path, options={}, raw=false, unformatted=false)
      request(:delete, path, options, raw, unformatted)
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

        puts request if debug
      end
      raw ? response : response.body
    end

    def formatted_path(path)
      [path, format].compact.join('.')
    end
  end

	class Client  

    VALID_OPTIONS_KEYS = [
      :customer_id,
      :customer_secret,
      :endpoint,
      :adapter,
      :format,
      :proxy,
      :user_agent
    ].freeze

    #TODO: refactor to attr_reader for better security
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

    # Creates a new client and sets instance variables to passed options or their default values
    def initialize(options={}) 
      option_hash = options.merge(options)
      @adapter         = option_hash[:adapter] || DEFAULT_ADAPTER
      @customer_id     = option_hash[:customer_id] || DEFAULT_CUSTOMER_ID
      @customer_secret = option_hash[:customer_secret] || DEFAULT_CUSTOMER_SECRET
      @endpoint        = option_hash[:endpoint] || DEFAULT_ENDPOINT
      @format          = option_hash[:format] || DEFAULT_FORMAT
      @proxy           = option_hash[:proxy] || DEFAULT_PROXY
      @user_agent      = option_hash[:user_agent] || DEFAULT_USER_AGENT
    end

    #convenience method for returning id/secret
    def creds
      Hash["customer_id" => customer_id, "customer_secret" => customer_secret]
    end


    #here comes the good stuff.  modules separated by Knodes resources, with methods for each api call
    module Customers
    	def customer
        
        # http://developer.knod.es/docs/customers/

        # PARAMETERS
        # Name         Description               Required?
        # USTOMER_ID  ID of customer to view.   Yes
    		response = get("customers", creds)
   		end

      def connect(options={})

        # http://developer.knod.es/docs/customers/connect

        # PARAMETERS
        # Name          Description                 Required?
        # CUSTOMER_ID   ID of customer to view.     Yes
        # network       Network being connected.    Yes
        # id            App identifier on network.  Yes
        # secret        App secret on network.      No

        #merge customer credentials, initial values will override provided values.
        options = options.merge(creds)
        response = post("customers/#{options[:customer_id]}/connect", options)
      end

      def disconnect(options={})

        # http://developer.knod.es/docs/customers/disconnect

        # PARAMETERS
        # Name          Description                 Required?
        # CUSTOMER_ID   ID of customer to view.     Yes
        # network       Network being disconnected. Yes

        options = options.merge(creds)
        response = post("customers/#{options[:customer_id]}/disconnect", options)
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