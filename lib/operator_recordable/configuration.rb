# frozen_string_literal: true

require "operator_recordable/store"

module OperatorRecordable
  class Configuration
    attr_reader :store

    def initialize(config)
      @config = initialize_config(config)
      @store = initialize_store
    end

    %i[operator_class_name creator_column_name updater_column_name deleter_column_name discarder_column_name
       creator_association_name updater_association_name deleter_association_name discarder_association_name
       operator_association_options operator_association_scope].each do |name|
      define_method name do
        config[name]
      end
    end

    def column_name_for(type)
      config[:"#{type}_column_name"]
    end

    def association_name_for(type)
      config[:"#{type}_association_name"]
    end

    private

    attr_reader :config

    def initialize_config(config) # rubocop:disable Metrics/MethodLength
      {
        operator_class_name: "Operator",
        creator_column_name: "created_by",
        updater_column_name: "updated_by",
        deleter_column_name: "deleted_by",
        discarder_column_name: "discarded_by",
        creator_association_name: "creator",
        updater_association_name: "updater",
        deleter_association_name: "deleter",
        discarder_association_name: "discarder",
        operator_association_options: {},
        operator_association_scope: nil,
        store: :thread_store
      }.merge!(config || {}).freeze
    end

    def initialize_store
      args = [*config[:store]]
      name = args.shift
      Store.fetch(name).new(*args)
    end

    class Model
      VALID_ACTIONS = %i[create update destroy discard].freeze

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

      def record_discarder?
        actions.include? :discard
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
