# frozen_string_literal: true

module OperatorRecordable
  class RequestStore < Store
    def [](key)
      ::RequestStore.store[store_key_for(key)]
    end

    def []=(key, value)
      ::RequestStore.store[store_key_for(key)] = value
    end
  end
end
