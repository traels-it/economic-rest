module Economic
  class Distribution < Base
    field :percentage

    relation :department, fields: [:departmentNumber]
  end
end
