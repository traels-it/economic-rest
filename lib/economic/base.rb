module Economic
  class Base
    def initialize(hash)
      self.class::ATTRIBUTES.each do |attribute|
        self.class.field attribute
      end
      self.class::OBJECTS.each do |objects|
        self.class.field objects
      end

      Hash.class_eval { include ExtraMethods }
      @internal_hash = hash
      @internal_hash.each do |k, v|
        send("#{k}=", v) if self.class::ATTRIBUTES.include?(k)
        if self.class::OBJECTS.include?(k)
          v.keys.count.times do |i|
            v.alias!(Base.snake_case(v.keys[i]), v.keys[i])
          end
          send("#{k}=", v)
        end
      end
    end

    def to_h
      @internal_hash
    end

    def dirty?
      self.class::ATTRIBUTES.each do |attribute|
        return true unless send(attribute) == @internal_hash[attribute]
      end
      false
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

module ExtraMethods
  def alias!(newkey, oldkey)
    self[newkey] = self[oldkey] if self.has_key?(oldkey)
    self
  end
end
