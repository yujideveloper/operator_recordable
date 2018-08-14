# frozen_string_literal: true

module OperatorRecordable
  class Configuration
    VALID_ACTIONS = %i[create update destroy].freeze

    def initialize(config)
      @config = initialize_config(config)

      return if Array(config[:actions]).all? &VALID_ACTIONS.method(:include?)
      raise ArgumentError, "valid actions are #{VALID_ACTIONS.inspect}."
    end

    %i[operator_class_name creator_column_name updater_column_name deleter_column_name
       operator_association_options operator_association_scope].each do |name|
      define_method name do
        config[name]
      end
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

    private

    attr_reader :config

    def initialize_config(config)
      {
        operator_class_name: "Operator",
        creator_column_name: "created_by",
        updater_column_name: "updated_by",
        deleter_column_name: "deleted_by",
        actions: VALID_ACTIONS,
        operator_association_options: {},
        operator_association_scope: nil
      }.merge!(config || {}).freeze
    end

    class PerModel
      def initialize(actions)
        @actions = actions
        return if actions.all? &VALID_ACTIONS.method(:include?)
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
