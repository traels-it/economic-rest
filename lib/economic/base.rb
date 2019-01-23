module Economic
  class Base
    def initialize(hash)
      values_based_on_hash(hash)
    end

    def self.field(name:, id: false)
      economic_cased_attibute_name = name
      attr_accessor economic_cased_attibute_name
      alias_method snake_case(economic_cased_attibute_name), economic_cased_attibute_name
      alias_method "#{snake_case(economic_cased_attibute_name)}=", "#{economic_cased_attibute_name}="
      alias_method 'id_key', name if id
    end

    def values_based_on_hash(hash)
      Hash.class_eval { include ExtraMethods }
      @internal_hash = hash
      @internal_hash.each do |k, v|
        k = k.to_s
        if self.class::ATTRIBUTES.include?(k)
          warn "#{k} in #{self.class.name} contains a Hash #{self.class.name}" if v.class == Hash
          send("#{k}=", v)
        elsif self.class::OBJECTS.include?(k)
          warn "#{k} in #{self.class.name} does not contain a Hash" unless v.class == Hash
          v.keys.count.times do |i|
            v.alias!(Base.snake_case(v.keys[i]), v.keys[i])
          end
          send("#{k}=", v)
        else
          warn "unassigned k #{k} in #{self.class.name}" unless %w[layout self soap metaData].include? k
        end
      end
    end

    def to_h
      self.class::ATTRIBUTES.each do |attribute|
        @internal_hash[attribute.to_sym] = send(attribute) unless send(attribute).nil?
      end
      self.class::OBJECTS.each do |object|
        @internal_hash[object.to_sym] = send(object) unless send(object).nil?
      end
      @internal_hash
    end

    def dirty?
      self.class::ATTRIBUTES.each do |attribute|
        return true unless send(attribute) == @internal_hash[attribute]
      end
      false
    end

    def save
      response = repo.save(self)
      values_based_on_hash(JSON.parse(response.body))
    end

    def self.snake_case(camel_cased)
      camel_cased.to_s.gsub(/::/, '/')
                 .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                 .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                 .tr('-', '_')
                 .downcase
    end

    def repo
      Object.const_get("#{self.class}Repo")
    end
  end
end

module ExtraMethods
  def alias!(newkey, oldkey)
    self[newkey] = self[oldkey] if self.has_key?(oldkey)
    self
  end
end
