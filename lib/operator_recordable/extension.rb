# frozen_string_literal: true

require "operator_recordable/recorder"

module OperatorRecordable
  module Extension
    def self.included(class_or_module)
      class_or_module.extend Recorder.new(OperatorRecordable.config)
    end
    private_class_method :included
  end
end
