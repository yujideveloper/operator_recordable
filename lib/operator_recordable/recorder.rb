# frozen_string_literal: true

require "operator_recordable/configuration"

module OperatorRecordable
  class Recorder < ::Module
    def initialize(config)
      define_activate_method(config)
      define_predicate_methods(config)
    end

    private

    def define_activate_method(config)
      m = self

      define_method :record_operator_on do |*actions|
        @_record_operator_on = Configuration::Model.new(actions)

        if __send__(:"record_#{config.creator_association_name}?")
          m.__send__(:run_creator_dsl, self, config)
          m.__send__(:define_creator_instance_methods, self, config)
        end

        if __send__(:"record_#{config.updater_association_name}?")
          m.__send__(:run_updater_dsl, self, config)
          m.__send__(:define_updater_instance_methods, self, config)
        end

        if __send__(:"record_#{config.deleter_association_name}?")
          m.__send__(:run_deleter_dsl, self, config)
          m.__send__(:define_deleter_instance_methods, self, config)
        end
      end
    end

    def run_creator_dsl(class_or_module, config)
      class_or_module.before_create :"assign_#{config.creator_association_name}"
      run_add_association_dsl(:creator, class_or_module, config)
    end

    def run_updater_dsl(class_or_module, config)
      class_or_module.before_save :"assign_#{config.updater_association_name}"
      run_add_association_dsl(:updater, class_or_module, config)
    end

    def run_deleter_dsl(class_or_module, config)
      class_or_module.before_destroy :"assign_#{config.deleter_association_name}"
      run_add_association_dsl(:deleter, class_or_module, config)
    end

    def run_add_association_dsl(type, class_or_module, config)
      class_or_module.belongs_to config.association_name_for(type).to_sym,
                                 config.operator_association_scope,
                                 { foreign_key: config.column_name_for(type),
                                   class_name: config.operator_class_name }.merge(config.operator_association_options)
    end

    def define_creator_instance_methods(class_or_module, config)
      class_or_module.class_eval <<~END_OF_DEF, __FILE__, __LINE__ + 1
        private def assign_#{config.creator_association_name}
          return unless (op = OperatorRecordable.operator)

          self.#{config.creator_column_name} = op.id
        end
      END_OF_DEF
    end

    def define_updater_instance_methods(class_or_module, config)
      class_or_module.class_eval <<~END_OF_DEF, __FILE__, __LINE__ + 1
        private def assign_#{config.updater_association_name}
          return if !self.new_record? && !self.changed?
          return unless (op = OperatorRecordable.operator)

          self.#{config.updater_column_name} = op.id
        end
      END_OF_DEF
    end

    def define_deleter_instance_methods(class_or_module, config)
      class_or_module.class_eval <<~END_OF_DEF, __FILE__, __LINE__ + 1
        private def assign_#{config.deleter_association_name}
          return if self.frozen?
          return unless (op = OperatorRecordable.operator)

          self
            .class
            .where(self.class.primary_key => id)
            .update_all('#{config.deleter_column_name}' => op.id)
          self.#{config.deleter_column_name} = op.id
        end
      END_OF_DEF
    end

    def define_predicate_methods(config)
      self.class_eval <<-END_OF_DEF, __FILE__, __LINE__ + 1
        private def record_#{config.creator_association_name}?
          instance_variable_defined?(:@_record_operator_on) &&
           @_record_operator_on.record_creator?
        end

        private def record_#{config.updater_association_name}?
          instance_variable_defined?(:@_record_operator_on) &&
            @_record_operator_on.record_updater?
        end

        private def record_#{config.deleter_association_name}?
          instance_variable_defined?(:@_record_operator_on) &&
            @_record_operator_on.record_deleter?
        end
      END_OF_DEF
    end
  end
end
