# frozen_string_literal: true

require "operator_recordable/store"
require "operator_recordable/configuration"

module OperatorRecordable
  class Recorder < ::Module
    attr_reader :configuration

    def initialize(config = {})
      @store = config.delete(:store) || ThreadStore.new
      @configuration = Configuration.new(config)
    end

    def operator
      @store[configuration.operator_class_name]
    end

    def operator=(operator)
      @store[configuration.operator_class_name] = operator
    end

    class InstanceMethodsBuilder < ::Module
      def initialize(store, config)
        define_method :operator do
          store[config.operator_class_name]
        end

        define_method :assign_creator do
          return unless (op = operator)
          self.__send__(:"#{config.creator_column_name}=", op.id)
        end
        private :assign_creator

        define_method :assign_updater do
          return if !self.new_record? && !self.changed?
          return unless (op = operator)
          self.__send__(:"#{config.updater_column_name}=", op.id)
        end
        private :assign_updater

        define_method :assign_deleter do
          return if self.frozen?
          return unless (op = operator)
          self.class
            .where(self.class.primary_key => id)
            .update_all(config.deleter_column_name => op.id)
          self.__send__(:"#{config.deleter_column_name}=", op.id)
        end
        private :assign_deleter
      end
    end

    class ClassMethodsBuilder < ::Module
      def initialize(store, config)
        define_method :operator do
          store[config.operator_class_name]
        end

        define_method :record_operator_on do |*actions|
          @_record_operator_on = Configuration::PerModel.new(actions)
        end

        define_method :record_creator? do
          config.record_creator? && (!instance_variable_defined?(:@_record_operator_on) || @_record_operator_on.record_creator?)
        end
        private :record_creator?

        define_method :record_updater? do
          config.record_updater? && (!instance_variable_defined?(:@_record_operator_on) || @_record_operator_on.record_updater?)
        end
        private :record_updater?

        define_method :record_deleter? do
          config.record_deleter? && (!instance_variable_defined?(:@_record_operator_on) || @_record_operator_on.record_deleter?)
        end
        private :record_deleter?
      end
    end

    def included(class_or_module)
      class_or_module.include InstanceMethodsBuilder.new(@store, configuration)
      class_or_module.extend  ClassMethodsBuilder.new(@store, configuration)
      config = configuration
      class_or_module.class_eval do
        before_create  :assign_creator if record_creator?
        before_save    :assign_updater if record_updater?
        before_destroy :assign_deleter if record_deleter?

        if record_creator?
          belongs_to :creator, config.operator_association_scope,
                     { foreign_key: config.creator_column_name, class_name: config.operator_class_name }.merge(config.operator_association_options)
        end
        if record_updater?
          belongs_to :updater, config.operator_association_scope,
                     { foreign_key: config.updater_column_name, class_name: config.operator_class_name }.merge(config.operator_association_options)
        end
        if record_deleter?
          belongs_to :deleter, config.operator_association_scope,
                     { foreign_key: config.deleter_column_name, class_name: config.operator_class_name }.merge(config.operator_association_options)
        end
      end
    end
  end
end
