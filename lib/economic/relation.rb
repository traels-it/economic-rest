module Economic
  class Relation < Data.define(:name, :as, :multiple, :klass)
    def economic_name
      return as.to_s unless as.to_s.blank?

      name.to_s.camelize(:lower)
    end

    def klass
      super&.constantize || "Economic::Models::#{name.to_s.classify}".constantize
    end

    def multiple?
      multiple
    end
  end
end
