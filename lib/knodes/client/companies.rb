module Knodes
	class Client
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
	end
end