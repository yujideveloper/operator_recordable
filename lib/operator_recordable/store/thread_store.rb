# frozen_string_literal: true

module OperatorRecordable
  class ThreadStore < Store
    def [](key)
      ::Thread.current[store_key_for(key)]
    end

    def []=(key, value)
      ::Thread.current[store_key_for(key)] = value
    end
  end
end
