# frozen_string_literal: true

module OperatorRecordable
  class Store
    private

    def store_key_for(key)
      :"operator_recordable_operator_#{key}"
    end
  end
end

require "operator_recordable/store/thread_store"
require "operator_recordable/store/request_store" if defined? ::RequestStore
require "operator_recordable/store/current_attributes_store" if defined? ::ActiveSupport::CurrentAttributes
