# frozen_string_literal: true

module OperatorRecordable
  class Store
    def self.operator_store_key
      :operator_recordable_operator
    end

    def self.register(name, klass)
      @stores ||= {}
      @stores[name] = klass
    end

    def self.fetch_class(name)
      @stores.fetch(name)
    end
  end
end

require "operator_recordable/store/thread_store"
require "operator_recordable/store/request_store" if defined? ::RequestStore
require "operator_recordable/store/current_attributes_store" if defined? ::ActiveSupport::CurrentAttributes
