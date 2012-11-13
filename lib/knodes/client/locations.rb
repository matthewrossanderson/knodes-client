module Knodes
	class Client
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
	end
end