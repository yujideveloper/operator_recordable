# frozen_string_literal: true

require "operator_recordable/configuration"

module OperatorRecordable
  class Recorder < ::Module
    def initialize(config)
      super()
      define_activate_method(config)
    end

    private

    def define_activate_method(config) # rubocop:disable Metrics/MethodLength
      m = self

      define_method :record_operator_on do |*actions| # rubocop:disable Metrics/MethodLength
        c = Configuration::Model.new(actions)

        if c.record_creator?
          m.__send__(:run_creator_dsl, self, config)
          m.__send__(:define_creator_instance_methods, self, config)
        end

        if c.record_updater?
          m.__send__(:run_updater_dsl, self, config)
          m.__send__(:define_updater_instance_methods, self, config)
        end

        if c.record_deleter?
          m.__send__(:run_deleter_dsl, self, config)
          m.__send__(:define_deleter_instance_methods, self, config)
        end

        if c.record_discarder?
          m.__send__(:run_discarder_dsl, self, config)
          m.__send__(:define_discarder_instance_methods, self, config)
        end
      end
    end

    def run_creator_dsl(klass, config)
      klass.before_create :"assign_#{config.creator_association_name}"
      run_add_association_dsl(:creator, klass, config)
    end

    def run_updater_dsl(klass, config)
      klass.before_save :"assign_#{config.updater_association_name}"
      run_add_association_dsl(:updater, klass, config)
    end

    def run_deleter_dsl(klass, config)
      klass.before_destroy :"assign_#{config.deleter_association_name}"
      run_add_association_dsl(:deleter, klass, config)
    end

    def run_discarder_dsl(klass, config)
      klass.before_discard :"assign_#{config.discarder_association_name}"
      run_add_association_dsl(:discarder, klass, config)
    end

    def run_add_association_dsl(type, klass, config)
      klass.belongs_to config.association_name_for(type).to_sym,
                       config.operator_association_scope,
                       **{ foreign_key: config.column_name_for(type),
                           class_name: config.operator_class_name,
                           optional: true }.merge(config.operator_association_options)
    end

    def define_creator_instance_methods(klass, config)
      klass.class_eval <<~END_OF_DEF, __FILE__, __LINE__ + 1
        private def assign_#{config.creator_association_name}  # private def assign_creator
          return unless (op = OperatorRecordable.operator)     #   return unless (op = OperatorRecordable.operator)
                                                               #
          self.#{config.creator_column_name} = op.id           #   self.created_by = op.id
        end                                                    # end
      END_OF_DEF
    end

    def define_updater_instance_methods(klass, config)
      klass.class_eval <<~END_OF_DEF, __FILE__, __LINE__ + 1
        private def assign_#{config.updater_association_name}  # private def assign_updater
          return if !self.new_record? && !self.changed?        #   return if !self.new_record? && !self.changed?
          return unless (op = OperatorRecordable.operator)     #   return unless (op = OperatorRecordable.operator)
                                                               #
          self.#{config.updater_column_name} = op.id           #   self.updated_by = op.id
        end                                                    # end
      END_OF_DEF
    end

    def define_deleter_instance_methods(klass, config)
      klass.class_eval <<~END_OF_DEF, __FILE__, __LINE__ + 1
        private def assign_#{config.deleter_association_name}      # private def assign_deleter
          return if self.frozen?                                   #   return if self.frozen?
          return unless (op = OperatorRecordable.operator)         #   return unless (op = OperatorRecordable.operator)
                                                                   #
          self                                                     #   self
            .class                                                 #     .class
            .where(self.class.primary_key => id)                   #     .where(self.class.primary_key => id)
            .update_all('#{config.deleter_column_name}' => op.id)  #     .update_all('deleted_by' => op.id)
          self.#{config.deleter_column_name} = op.id               #   self.deleted_by = op.id
        end                                                        # end
      END_OF_DEF
    end

    def define_discarder_instance_methods(klass, config)
      klass.class_eval <<~END_OF_DEF, __FILE__, __LINE__ + 1
        private def assign_#{config.discarder_association_name}      # private def assign_discarder
          return if self.frozen?                                     #   return if self.frozen?
          return unless (op = OperatorRecordable.operator)           #   return unless (op = OperatorRecordable.operator)
                                                                     #
          self                                                       #   self
            .class                                                   #     .class
            .where(self.class.primary_key => id)                     #     .where(self.class.primary_key => id)
            .update_all('#{config.discarder_column_name}' => op.id)  #     .update_all('discarded_by' => op.id)
          self.#{config.discarder_column_name} = op.id               #   self.discarded_by = op.id
        end                                                          # end
      END_OF_DEF
    end
  end
end
