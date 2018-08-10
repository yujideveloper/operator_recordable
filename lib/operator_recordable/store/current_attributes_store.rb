# frozen_string_literal: true

module OperatorRecordable
  class CurrentAttributesStore < Store
    class Current < ::ActiveSupport::CurrentAttributes
      attribute :store

      def [](key)
        return nil unless self.store
        self.store[key]
      end

      def []=(key, value)
        self.store ||= {}
        self.store[key] = value
      end
    end

    def [](key)
      Current[store_key_for(key)]
    end

    def []=(key, value)
      Current[store_key_for(key)] = value
    end
  end
end
