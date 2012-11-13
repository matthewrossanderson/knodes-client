module Knodes
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

        puts response.inspect if debug
      end
      raw ? response : response.body
    end

    def formatted_path(path)
      [path, format].compact.join('.')
    end
  end
end