module Knodes
	class Client
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

      def user_update(options={})
        response = post("users/#{options[:user_id]}", options.merge(creds))
      end

      def user_notify_active(options={})
        response = post("users/notify_active", options.merge(creds))
      end

      def user_notify_inactive(options={})
        #do a raw request/response (don't parse), as this method only returns an http status
        response = post("users/notify_inactive", options.merge(creds), true)
        status = response.env[:status]
      end

      def user_ready(options={})
        response = get("users/#{options[:user_id]}/ready", options.merge(creds), true)
        body = response.env[:body]
      end

      def user_do_index(options={})
        response = post("users/#{options[:user_id]}/do_index", options.merge(creds), true)
        status = response.env[:status]
      end
    end
	end
end