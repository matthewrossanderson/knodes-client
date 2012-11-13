module Knodes
  class Client
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
  end
end