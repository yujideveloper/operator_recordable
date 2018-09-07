# frozen_string_literal: true

module OperatorRecordable
  class CurrentAttributesStore
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
      Current[key]
    end

    def []=(key, value)
      Current[key] = value
    end
  end

  Store.register(:current_attributes_store, CurrentAttributesStore)
end
