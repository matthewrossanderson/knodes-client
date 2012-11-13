module Knodes
	class Client
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
	end
end