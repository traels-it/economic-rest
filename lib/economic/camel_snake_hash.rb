module Economic
  class CamelSnakeHash < Hash
    def initialize(hash)
      hash.each do |k,v|
        self[k] = v
      end
    end

    def [](key)
      super _snake_case(key)
    end

    def []=(key, value)
      super _snake_case(key), value
    end

    # Keeping it DRY.
    protected

    def _insensitive(key)
      key.respond_to?(:upcase) ? key.upcase : key
    end

    def _snake_case(camel_cased)
      camel_cased.gsub(/::/, '/')
                 .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                 .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                 .tr('-', '_')
                 .downcase
    end
  end
end
