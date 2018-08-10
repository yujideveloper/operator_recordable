# frozen_string_literal: true

module OperatorRecordable
  class Configuration
    VALID_ACTIONS = %i[create update destroy].freeze

    def initialize(config)
      @config = initialize_config(config)

      return if Array(config[:actions]).all?{ |a| VALID_ACTIONS.include?(a) }
      raise ArgumentError, "valid actions are #{VALID_ACTIONS.inspect}."
    end

    def initialize_config(config)
      {
        operator_class_name: "Operator",
        creator_column_name: "created_by",
        updater_column_name: "updated_by",
        deleter_column_name: "deleted_by",
        actions: VALID_ACTIONS,
        operator_association_options: {},
        operator_association_scope: nil
      }.merge!(config || {})
    end

    def operator_class_name
      config[:operator_class_name]
    end

    def creator_column_name
      config[:creator_column_name]
    end

    def updater_column_name
      config[:updater_column_name]
    end

    def deleter_column_name
      config[:deleter_column_name]
    end

    def record_creator?
      config[:actions].include? :create
    end

    def record_updater?
      config[:actions].include? :update
    end

    def record_deleter?
      config[:actions].include? :destroy
    end

    def operator_association_options
      config[:operator_association_options]
    end

    def operator_association_scope
      config[:operator_association_scope]
    end

    private

    attr_reader :config

    class PerModel
      def initialize(actions)
        @actions = actions
        return if actions.all?{ |a| VALID_ACTIONS.include?(a) }
        raise ArgumentError, "valid actions are #{VALID_ACTIONS.inspect}."
      end

      def record_creator?
        actions.include? :create
      end

      def record_updater?
        actions.include? :update
      end

      def record_deleter?
        actions.include? :destroy
      end

      private

      attr_reader :actions
    end
  end
end
