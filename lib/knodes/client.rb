module Knodes
  class Client

    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

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

    include Connection
    include Request

    #here comes the good stuff.  
    #these refer to modules separated by Knodes resources, containing methods for each api call

    include Customers
    include Users
    include People
    include Documents
    include Locations
    include Companies
    include Schools
  end 
end