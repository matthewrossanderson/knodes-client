module Knodes
	class Client
    module Documents
      def document(options={})
        response = get("documents/#{options[:doc_id]}", options.merge(creds))
      end

      def documents_search(options={})
        response = get("documents/search", options.merge(creds))
      end

      def document_people(options={})
        response = get("documents/#{options[:doc_id]}/people", options.merge(creds))
      end

      def document_locations(options={})
        response = get("documents/#{options[:doc_id]}/locations", options.merge(creds))
      end
    end
	end
end