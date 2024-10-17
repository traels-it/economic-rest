module Economic
  class Model
    class << self
      attr_reader :attributes, :relations

      def field(name, as: nil)
        (@attributes ||= []) << Attribute.new(name:, as:)
        attr_accessor name
      end

      def relation(name, as: nil, fields: [], multiple: false)
        (@relations ||= []) << Relation.new(name:, as:, fields:, multiple:)
        attr_accessor name
      end

      def from_json(json)
        hash = JSON.parse(json)
        translated_attributes = translate_attributes(hash)
        translated_relations = translate_relations(hash, translated_attributes)
        new(**translated_relations)
      end

      private

      def translate_attributes(hash)
        economic_attribute_names = attributes.map(&:economic_name)
        attributes_hash = hash.slice(*economic_attribute_names)

        attributes_hash.each_with_object({}) do |(key, value), result|
          attribute = attributes.find { |attr| attr.as.to_s == key || attr.name.to_s.camelize(:lower) == key }
          result[attribute.name] = value
        end
      end

      def translate_relations(hash, translated_attributes)
        return translated_attributes unless relations&.any?

        economic_relation_names = relations.map(&:economic_name)
        relations_hash = hash.slice(*economic_relation_names)

        relations_hash.each_with_object(translated_attributes) do |(key, value), result|
          relation = relations.find { |rel| rel.as.to_s == key || rel.name.to_s.camelize(:lower) == key }
          result[relation.name] = relation.multiple? ? value.map { relation.klass.from_json(_1.to_json) } : relation.klass.from_json(value.to_json)
        end
      end
    end

    def initialize(**kwargs)
      valid_keys = self.class.attributes.map(&:name) + (self.class.relations&.map(&:name) || [])
      invalid_keys = kwargs.keys - valid_keys
      raise ArgumentError, "invalid keys: #{invalid_keys.join(', ')}" unless invalid_keys.empty?

      self.class.attributes.each { |attribute| instance_variable_set "@#{attribute.name}", kwargs[attribute.name] }
      self.class.relations&.each { |relation| instance_variable_set "@#{relation.name}", relation_value(relation, kwargs) }
    end

    def to_h
      result = {}
      self.class.attributes.each_with_object(result) { |attribute, hash| hash[attribute.economic_name] = instance_variable_get "@#{attribute.name}" }
      self.class.relations&.each_with_object(result) { |relation, hash| hash[relation.economic_name] = relation_to_h(relation) }
      result.compact
    end

    def to_json
      to_h.to_json
    end

    private

    def relation_value(relation, kwargs)
      relation.multiple? ? (kwargs[relation.name] || []) : kwargs[relation.name]
    end

    def relation_to_h(relation)
      value = instance_variable_get("@#{relation.name}")
      return if value.nil? || (value.respond_to?(:empty?) && value.empty?)

      relation.multiple? ? value.map(&:to_h) : value.to_h
    end
  end
end
