module Economic
  class CustomerContactRepo < Economic::NestedBaseRepo
    self.endpoint = "contacts"
  end
end
