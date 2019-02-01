module Economic
  class Base
    def initialize(hash)
      values_based_on_hash(hash)
    end

    class << self
      attr_reader :attributes
    end

    def self.add_attribute(name)
      (@attributes ||= []).push(name)
    end

    def self.field(name, id: false, model: nil)
      economic_cased_attibute_name = name.to_s
      attr_accessor economic_cased_attibute_name
      alias_method snake_case(economic_cased_attibute_name), economic_cased_attibute_name
      alias_method "#{snake_case(economic_cased_attibute_name)}=", "#{economic_cased_attibute_name}="
      alias_method 'id_key', economic_cased_attibute_name if id
      add_attribute economic_cased_attibute_name
      if model
        define_method("create_#{economic_cased_attibute_name[0...-1]}") do |class_instance|
          repo.save(self, submodel: class_instance)
        end
      end
    end

    def values_based_on_hash(hash)
      Hash.class_eval { include ExtraMethods }
      @internal_hash = hash
      @internal_hash.each do |k, v|
        k = k.to_s
        if self.class.attributes.include? k
          if v.class == Hash
            v.keys.count.times do |i|
              v.alias!(Base.snake_case(v.keys[i]), v.keys[i])
            end
          end
          send("#{k}=", v)
        else
          warn "unassigned k #{k} in #{self.class.name}" unless %w[layout self soap metaData].include? k
        end
      end
    end

    def to_h
      self.class.attributes.each do |attribute|
        @internal_hash[attribute.to_sym] = send(attribute) unless send(attribute).nil?
      end
      @internal_hash
    end

    def dirty?
      self.class.attributes.each do |attribute|
        return true unless send(attribute) == @internal_hash[attribute]
      end
      false
    end

    def save
      if dirty?
        response = repo.save(self)
        values_based_on_hash(JSON.parse(response.body))
      end
    end

    def self.snake_case(camel_cased)
      camel_cased.to_s.gsub(/::/, '/')
                 .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                 .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                 .tr('-', '_')
                 .downcase
    end

    def self.low_camel_case(snake_cased)
      camel = snake_cased.split('_').collect(&:capitalize).join
      camel[0, 1].downcase + camel[1..-1]
    end

    def repo
      Object.const_get("#{self.class}Repo")
    end
  end
end

module ExtraMethods
  def alias!(newkey, oldkey)
    self[newkey] = self[oldkey] if key?(oldkey)
    self
  end
end
