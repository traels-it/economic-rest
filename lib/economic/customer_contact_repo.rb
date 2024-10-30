module Economic
  class CustomerContactRepo < Economic::NestedBaseRepo
    self.endpoint = "contacts"
  end

  deprecate_constant :CustomerContactRepo
end
