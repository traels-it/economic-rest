class Hashit
  def initialize(hash)
    hash.each do |k, v|
      k = snake_case(k)
      instance_variable_set("@#{k}", v.is_a?(Hash) ? Hashit.new(v) : v)
      self.class.send(:define_method, snake_case(k), proc { instance_variable_get("@#{k}") })
      self.class.send(:define_method, "#{k}=", proc { |v| instance_variable_set("@#{k}", v) })
    end
  end

  def snake_case(camel_cased)
    camel_cased.gsub(/::/, '/')
               .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
               .gsub(/([a-z\d])([A-Z])/, '\1_\2')
               .tr('-', '_')
               .downcase
  end
end
