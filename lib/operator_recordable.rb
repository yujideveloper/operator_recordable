# frozen_string_literal: true

require "operator_recordable/version"
require "operator_recordable/configuration"
require "operator_recordable/store"
require "operator_recordable/recorder"

module OperatorRecordable
  def self.config
    self.config = {} unless instance_variable_defined? :@config
    @config
  end

  def self.config=(config)
    @config = Configuration.new(config)
  end

  def self.operator
    config.store[Store.operator_store_key]
  end

  def self.operator=(operator)
    config.store[Store.operator_store_key] = operator
  end

  def self.included(class_or_module)
    class_or_module.extend Recorder.new(config)
  end
end
