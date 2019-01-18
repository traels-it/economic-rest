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
    end
  end
end
