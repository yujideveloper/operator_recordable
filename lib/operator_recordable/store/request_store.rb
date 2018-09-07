# frozen_string_literal: true

module OperatorRecordable
  class RequestStore
    def [](key)
      ::RequestStore.store[key]
    end

    def []=(key, value)
      ::RequestStore.store[key] = value
    end
  end
  Store.register(:request_store, RequestStore)
end
