# frozen_string_literal: true

require "operator_recordable/store"

module OperatorRecordable
  class Configuration
    attr_reader :store

    def initialize(config)
      @config = initialize_config(config)
      initialize_store
    end

    %i[operator_class_name creator_column_name updater_column_name deleter_column_name
       operator_association_options operator_association_scope].each do |name|
      define_method name do
        config[name]
      end
    end

    private

    attr_reader :config

    def initialize_config(config)
      {
        operator_class_name: "Operator",
        creator_column_name: "created_by",
        updater_column_name: "updated_by",
        deleter_column_name: "deleted_by",
        operator_association_options: {},
        operator_association_scope: nil,
        store: :thread_store
      }.merge!(config || {}).freeze
    end

    def initialize_store
      args = [*config[:store]]
      name = args.shift
      @store = Store.fetch_class(name).new(*args)
    end

    class Model
      VALID_ACTIONS = %i[create update destroy].freeze

      def initialize(actions)
        @actions = actions
        assert_actions
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

      def assert_actions
        return if actions.all?(&VALID_ACTIONS.method(:include?))
        raise ArgumentError, "valid actions are #{VALID_ACTIONS.inspect}."
      end
    end
  end
end
