module Economic
  class Base
    def initialize(hash = {})
      values_based_on_hash(hash)
    end

    class << self
      attr_reader :attributes, :relations
    end

    def self.add_attribute(name)
      (@attributes ||= []).push(name)
    end

    def self.add_relation(name, fields, multiple)
      (@relations ||= []).push(name: name, fields: fields, multiple: multiple)
    end

    def self.field(name, id: false)
      economic_cased_attibute_name = name.to_s
      attr_accessor economic_cased_attibute_name
      alias_method snake_case(economic_cased_attibute_name), economic_cased_attibute_name
      alias_method "#{snake_case(economic_cased_attibute_name)}=", "#{economic_cased_attibute_name}="
      alias_method "id_key", economic_cased_attibute_name if id
      alias_method "id_key=", "#{economic_cased_attibute_name}=" if id
      add_attribute economic_cased_attibute_name
    end

    def self.relation(name, fields:, multiple: false)
      economic_cased_attibute_name = name.to_s
      add_relation economic_cased_attibute_name, fields, multiple
      attr_accessor economic_cased_attibute_name
      alias_method "#{snake_case(economic_cased_attibute_name)}=", "#{economic_cased_attibute_name}="
      alias_method snake_case(economic_cased_attibute_name), economic_cased_attibute_name
    end

    def values_based_on_hash(hash)
      @internal_hash = hash || {}
      self.class.attributes.each do |field_name|
        public_send("#{field_name}=", @internal_hash[field_name] || @internal_hash[field_name.to_sym])
      end

      self.class.relations&.each do |relation_hash|
        relation_name = relation_hash[:name]
        if relation_hash[:multiple]
          model_name = relation_hash[:name].singularize
          related_model_array = Array(@internal_hash[relation_name])&.map { |data|
            model_class(model_name).new(data)
          }
          instance_variable_set("@#{relation_name}", related_model_array)
        else
          related_model = model_class(relation_name).new(@internal_hash[relation_name])
          instance_variable_set("@#{relation_name}", related_model)
        end
        if related_model
          unless @internal_hash[relation_name.to_sym].blank?
            related_model.values_based_on_hash(@internal_hash[relation_name.to_sym].to_h)
          end
        end
      end
    end

    def to_h(only_fields: [])
      return_hash = {}

      self.class.attributes.each do |field_name|
        next if only_fields.any? && !only_fields.include?(field_name.to_sym)

        return_hash[field_name] = public_send(field_name) if public_send(field_name)
      end

      self.class.relations&.each do |relation_hash|
        if relation_hash[:multiple]
          relation_name = relation_hash[:name]
          relation_fields = relation_hash[:fields]
          begin
            arr = public_send(relation_name).map { |relation| relation.to_h(only_fields: relation_fields) }
            return_hash[relation_name] = arr
          rescue NoMethodError
          end
        else
          relation_name = relation_hash[:name]
          relation_fields = relation_hash[:fields]

          relation_data = public_send(relation_name).to_h(only_fields: relation_fields)

          return_hash[relation_name] = relation_data unless relation_data.empty?
        end
      end
      return_hash
    end

    def self.snake_case(camel_cased)
      camel_cased.to_s.gsub(/::/, "/")
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr("-", "_")
        .downcase
    end

    def self.low_camel_case(snake_cased)
      camel = snake_cased.split("_").collect(&:capitalize).join
      camel[0, 1].downcase + camel[1..-1]
    end

    def repo
      Object.const_get("#{self.class}Repo")
    end

    def model_class(name)
      Object.const_get("Economic::" + name.slice(0, 1).capitalize + name.slice(1..-1))
    end
  end
end
