# frozen_string_literal: true

require "operator_recordable/store"
require "operator_recordable/configuration"
require "operator_recordable/operator"

module OperatorRecordable
  class Recorder < ::Module
    def initialize(store, config)
      define_activate_method(store, config)
      define_predicate_methods
    end

    private

    def define_activate_method(store, config)
      operator_reader_module = Operator::ReaderMethodBuilder.new(store)
      m = self

      define_method :record_operator_on do |*actions|
        @_record_operator_on = Configuration::Model.new(actions)

        include operator_reader_module
        extend operator_reader_module

        if record_creator?
          m.__send__(:run_creator_dsl, self, config)
          m.__send__(:define_creator_instance_methods, self, config)
        end

        if record_updater?
          m.__send__(:run_updater_dsl, self, config)
          m.__send__(:define_updater_instance_methods, self, config)
        end

        if record_deleter?
          m.__send__(:run_deleter_dsl, self, config)
          m.__send__(:define_deleter_instance_methods, self, config)
        end
      end
    end

    def run_creator_dsl(class_or_module, config)
      class_or_module.class_exec do
        before_create :assign_creator
        belongs_to :creator, config.operator_association_scope,
                    { foreign_key: config.creator_column_name,
                      class_name: config.operator_class_name }.merge(config.operator_association_options)
      end
    end

    def run_updater_dsl(class_or_module, config)
      class_or_module.class_exec do
        before_save :assign_updater
        belongs_to :updater, config.operator_association_scope,
                    { foreign_key: config.updater_column_name,
                      class_name: config.operator_class_name }.merge(config.operator_association_options)
      end
    end

    def run_deleter_dsl(class_or_module, config)
      class_or_module.class_exec do
        before_destroy :assign_deleter
        belongs_to :deleter, config.operator_association_scope,
                    { foreign_key: config.deleter_column_name,
                      class_name: config.operator_class_name }.merge(config.operator_association_options)
      end
    end

    def define_creator_instance_methods(class_or_module, config)
      class_or_module.class_exec do
        define_method :assign_creator do
          return unless (op = self.operator)

          self.__send__(:"#{config.creator_column_name}=", op.id)
        end
        private :assign_creator
      end
    end

    def define_updater_instance_methods(class_or_module, config)
      class_or_module.class_exec do
        define_method :assign_updater do
          return if !self.new_record? && !self.changed?
          return unless (op = self.operator)

          self.__send__(:"#{config.updater_column_name}=", op.id)
        end
        private :assign_updater
      end
    end

    def define_deleter_instance_methods(class_or_module, config)
      class_or_module.class_exec do
        define_method :assign_deleter do
          return if self.frozen?
          return unless (op = self.operator)

          self
            .class
            .where(self.class.primary_key => id)
            .update_all(config.deleter_column_name => op.id)
          self.__send__(:"#{config.deleter_column_name}=", op.id)
        end
        private :assign_deleter
      end
    end

    def define_predicate_methods
      define_method :record_creator? do
        instance_variable_defined?(:@_record_operator_on) &&
          @_record_operator_on.record_creator?
      end
      private :record_creator?

      define_method :record_updater? do
        instance_variable_defined?(:@_record_operator_on) &&
          @_record_operator_on.record_updater?
      end
      private :record_updater?

      define_method :record_deleter? do
        instance_variable_defined?(:@_record_operator_on) &&
          @_record_operator_on.record_deleter?
      end
      private :record_deleter?
    end
  end
end
