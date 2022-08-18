# frozen_string_literal: true

module OperatorRecordable
  class ThreadStore
    def initialize
      warn "DEPRECATION WARNING: `:thread_store` is deprecated. It will be removed in v2.0"
    end

    def [](key)
      ::Thread.current[key]
    end

    def []=(key, value)
      ::Thread.current[key] = value
    end
  end

  Store.register(:thread_store, ThreadStore)
end
