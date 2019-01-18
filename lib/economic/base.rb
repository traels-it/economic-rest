module Economic
  class Base
    def initialize(hash)
      self.class::ATTRIBUTES.each do |attribute|
        self.class.field attribute
      end
      @internal_hash = hash
      @internal_hash.each do |k, v|
        send("#{k}=", v) if self.class::ATTRIBUTES.include?(k)
      end
    end

    def to_h
      @internal_hash
    end

    def self.field(economic_cased_attibute_name)
      attr_accessor economic_cased_attibute_name
      alias_method snake_case(economic_cased_attibute_name), economic_cased_attibute_name
      alias_method "#{snake_case(economic_cased_attibute_name)}=", "#{economic_cased_attibute_name}="
    end

    def self.snake_case(camel_cased)
      camel_cased.gsub(/::/, '/')
                 .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                 .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                 .tr('-', '_')
                 .downcase
    end

  end
end
