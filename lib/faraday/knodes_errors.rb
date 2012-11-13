require 'faraday'
require File.expand_path('../../knodes/error', __FILE__)

module FaradayMiddleware
  class KnodesErrors < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |response|
        case response[:status].to_i
          when 400
            raise Knodes::BadRequest, response[:body]
            #puts "#{finished_env[:body] if finished_env[:body]}"
          when 404
            raise Knodes::NotFound, response[:body]
            #puts "#{finished_env if finished_env[:body]}"
        end
      end
    end
    def initialize(app)
        super app
        @parser = nil
    end
  end
end