# frozen_string_literal: true

require "operator_recordable/version"
require "operator_recordable/configuration"
require "operator_recordable/extension"

module OperatorRecordable
  def self.config
    self.config = {} unless instance_variable_defined? :@config
    @config
  end

  def self.config=(config)
    @config = Configuration.new(config)
  end

  def self.operator
    config.store[operator_store_key]
  end

  def self.operator=(operator)
    config.store[operator_store_key] = operator
  end

  def self.operator_store_key
    :operator_recordable_operator
  end
  private_class_method :operator_store_key
end
