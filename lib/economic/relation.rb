module Economic
  class Relation < Data.define(:name, :as, :fields, :multiple)
    def economic_name
      return as.to_s unless as.to_s.blank?

      name.to_s.camelize(:lower)
    end

    def klass
      "Economic::#{name.to_s.classify}".constantize
    end

    def multiple?
      multiple
    end
  end
end
