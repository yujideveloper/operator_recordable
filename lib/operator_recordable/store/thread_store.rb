# frozen_string_literal: true

module OperatorRecordable
  class ThreadStore
    def [](key)
      ::Thread.current[key]
    end

    def []=(key, value)
      ::Thread.current[key] = value
    end
  end

  Store.register(:thread_store, ThreadStore)
end
