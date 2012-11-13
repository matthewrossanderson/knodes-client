module Knodes
	class Client
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
	end
end