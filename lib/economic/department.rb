module Economic
  class Department < Base
    field :name
    field :departmentNumber, id: true
  end
end
