#require the shiny custom middleware
Dir[File.expand_path('../../faraday/*.rb', __FILE__)].each{|f| require f}

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
        connection.request :url_encoded
        connection.response :mashify unless raw
        connection.response :json, content_type: 'application/json' unless raw  
        connection.use FaradayMiddleware::KnodesErrors
        connection.adapter(adapter)
  		end
  	end
  end
end