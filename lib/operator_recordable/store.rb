# frozen_string_literal: true

module OperatorRecordable
  module Store
    def self.register(name, klass)
      @stores ||= {}
      @stores[name] = klass
    end

    def self.fetch(name)
      @stores.fetch(name)
    end
  end
end

require "operator_recordable/store/thread_store"
require "operator_recordable/store/request_store" if defined? ::RequestStore
require "operator_recordable/store/current_attributes_store" if defined? ::ActiveSupport::CurrentAttributes
