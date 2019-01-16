
module Economic
  class Customer
    def initialize(hash)
      @internal_hash = hash
    end

    def to_h
      @internal_hash
    end
  end
end
