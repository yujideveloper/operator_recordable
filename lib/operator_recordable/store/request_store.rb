# frozen_string_literal: true

module OperatorRecordable
  class RequestStore < Store
    def [](key)
      ::RequestStore.current[store_key_for(key)]
    end

    def []=(key, value)
      ::RequestStore.current[store_key_for(key)] = value
    end
  end
end
