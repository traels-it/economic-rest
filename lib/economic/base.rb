module Economic
  class Base
    def initialize(hash)
      values_based_on_hash(hash)
    end

    class << self
      attr_reader :attributes, :relations
    end

    def self.add_attribute(name)
      (@attributes ||= []).push(name)
    end

    def self.add_relation(name, fields)
      (@relations ||= []).push(name: name, fields: fields)
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

    def self.relation(name, fields:)
      economic_cased_attibute_name = name.to_s
      add_relation economic_cased_attibute_name, fields
      attr_reader economic_cased_attibute_name
      alias_method snake_case(economic_cased_attibute_name), economic_cased_attibute_name
    end

    def values_based_on_hash(hash)
      @internal_hash = hash || {}

      self.class.attributes.each do |field_name|
        public_send("#{field_name}=", @internal_hash[field_name])
      end

      if self.class.relations
        self.class.relations.each do |relation_hash|
          name = relation_hash[:name]
          related_model = model_class(name).new(@internal_hash[name])

          instance_variable_set("@#{name}", related_model)
        end
      end
    end

    def to_h(only_fields: [])
      return_hash = {}

      self.class.attributes.each do |field_name|
        next if only_fields.any? && !only_fields.include?(field_name.to_sym)

        return_hash[field_name] = public_send(field_name) if public_send(field_name)
      end

      if self.class.relations
        self.class.relations.each do |relation_hash|
          relation_name = relation_hash[:name]
          relation_fields = relation_hash[:fields]

          relation_data = public_send(relation_name).to_h(only_fields: relation_fields)

          return_hash[relation_name] = relation_data unless relation_data.empty?
        end
      end
      return_hash
    end

    def dirty?
      self.class.attributes.each do |attribute|
        return true unless send(attribute) == @internal_hash[attribute]
      end
      false
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

    def model_class(name)
      Object.const_get('Economic::' + name.slice(0, 1).capitalize + name.slice(1..-1))
    end
  end
end
