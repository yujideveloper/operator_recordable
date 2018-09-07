# frozen_string_literal: true

require "operator_recordable/store"

module OperatorRecordable
  module Operator
    class ReaderMethodBuilder < ::Module
      def initialize(store)
        define_method :operator do
          store[Store.operator_store_key]
        end
      end
    end
  end
end
