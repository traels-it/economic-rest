module Economic
  class Attribute < Data.define(:name, :as)
    def economic_name
      return as.to_s unless as.to_s.blank?

      name.to_s.camelize(:lower)
    end
  end
end
