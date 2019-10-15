module Economic
  class NestedBaseRepo < Economic::BaseRepo
    class << self
      def all(filter_text: "", on: nil)
        pagination = {}
        pageindex = 0
        entries = []

        # Loop until last page, last page does not have a 'nextPage'
        while pagination["nextPage"] || pageindex.zero?
          response = fetch(pageindex: pageindex, filter_text: filter_text, model: on)

          hash = JSON.parse(response.body)
          hash["collection"].each do |entry_hash|
            entries.push model.new(entry_hash)
          end

          pagination = hash["pagination"]
          pageindex += 1
        end
        entries
      end

      def endpoint_url(model)
        Economic::BaseRepo::URL + endpoint_name(model)
      end

      def endpoint_name(model)
        "#{kebab(model.class.name.demodulize.pluralize)}/#{model.id_key}/#{super()}"
      end

      def fetch(pageindex: 0, filter_text: "", model: nil)
        url = endpoint_url(model)
        url << "?skippages=#{pageindex}&pagesize=1000"
        url << "&filter=#{filter_text}" unless filter_text == ""

        send_request(method: :get, url: URI.escape(url))
      end
    end
  end
end
