# frozen_string_literal: true

require "spec_helper"

RSpec.describe OperatorRecordable::Configuration do
  describe "#store" do
    subject { described_class.new(config).store }

    context "when store is not specified" do
      let(:config) { {} }

      it { is_expected.to be_an_instance_of OperatorRecordable::ThreadStore }
    end

    context "when store is :thread_store" do
      let(:config) { { store: :thread_store } }

      it { is_expected.to be_an_instance_of OperatorRecordable::ThreadStore }
    end

    context "when store is :request_store" do
      let(:config) { { store: :request_store } }

      if defined? ::RequestStore
        it { is_expected.to be_an_instance_of OperatorRecordable::RequestStore }
      else
        it { expect { subject }.to raise_error KeyError }
      end
    end

    context "when store is :current_attributes_store" do
      let(:config) { { store: :current_attributes_store } }

      it { is_expected.to be_an_instance_of OperatorRecordable::CurrentAttributesStore }
    end
  end

  describe "#operator_class_name" do
    subject { described_class.new(config).operator_class_name }

    context "when operator_class_name is not specified" do
      let(:config) { {} }

      it { is_expected.to eq "Operator" }
    end

    context "when operator_class_name is specified" do
      let(:config) { { operator_class_name: "Account" } }

      it { is_expected.to eq "Account" }
    end
  end

  describe "#creator_column_name" do
    subject { described_class.new(config).creator_column_name }

    context "when creator_column_name is not specified" do
      let(:config) { {} }

      it { is_expected.to eq "created_by" }
    end

    context "when creator_column_name is specified" do
      let(:config) { { creator_column_name: "created_operator_id" } }

      it { is_expected.to eq "created_operator_id" }
    end
  end

  describe "#updater_column_name" do
    subject { described_class.new(config).updater_column_name }

    context "when updater_column_name is not specified" do
      let(:config) { {} }

      it { is_expected.to eq "updated_by" }
    end

    context "when updater_column_name is specified" do
      let(:config) { { updater_column_name: "updated_operator_id" } }

      it { is_expected.to eq "updated_operator_id" }
    end
  end

  describe "#deleter_column_name" do
    subject { described_class.new(config).deleter_column_name }

    context "when deleter_column_name is not specified" do
      let(:config) { {} }

      it { is_expected.to eq "deleted_by" }
    end

    context "when deleter_column_name is specified" do
      let(:config) { { deleter_column_name: "deleted_operator_id" } }

      it { is_expected.to eq "deleted_operator_id" }
    end
  end

  describe "#discarder_column_name" do
    subject { described_class.new(config).discarder_column_name }

    context "when discarder_column_name is not specified" do
      let(:config) { {} }

      it { is_expected.to eq "discarded_by" }
    end

    context "when discarder_column_name is specified" do
      let(:config) { { discarder_column_name: "discarded_operator_id" } }

      it { is_expected.to eq "discarded_operator_id" }
    end
  end

  describe "#creator_association_name" do
    subject { described_class.new(config).creator_association_name }

    context "when creator_association_name is not specified" do
      let(:config) { {} }

      it { is_expected.to eq "creator" }
    end

    context "when creator_association_name is specified" do
      let(:config) { { creator_association_name: "created_operator" } }

      it { is_expected.to eq "created_operator" }
    end
  end

  describe "#updater_association_name" do
    subject { described_class.new(config).updater_association_name }

    context "when updater_association_name is not specified" do
      let(:config) { {} }

      it { is_expected.to eq "updater" }
    end

    context "when updater_association_name is specified" do
      let(:config) { { updater_association_name: "updated_operator" } }

      it { is_expected.to eq "updated_operator" }
    end
  end

  describe "#deleter_association_name" do
    subject { described_class.new(config).deleter_association_name }

    context "when deleter_association_name is not specified" do
      let(:config) { {} }

      it { is_expected.to eq "deleter" }
    end

    context "when deleter_association_name is specified" do
      let(:config) { { deleter_association_name: "deleter_operator" } }

      it { is_expected.to eq "deleter_operator" }
    end
  end

  describe "#discarder_association_name" do
    subject { described_class.new(config).discarder_association_name }

    context "when discarder_association_name is not specified" do
      let(:config) { {} }

      it { is_expected.to eq "discarder" }
    end

    context "when discarder_association_name is specified" do
      let(:config) { { discarder_association_name: "discarded_operator" } }

      it { is_expected.to eq "discarded_operator" }
    end
  end

  describe "#operator_association_options" do
    subject { described_class.new(config).operator_association_options }

    context "when operator_association_options is not specified" do
      let(:config) { {} }

      it { is_expected.to match({}) }
    end

    context "when operator_association_options is specified" do
      let(:config) { { operator_association_options: { touch: true } } }

      it { is_expected.to match touch: true }
    end
  end

  describe "#operator_association_scope" do
    subject { described_class.new(config).operator_association_scope }

    context "when operator_association_scope is not specified" do
      let(:config) { {} }

      it { is_expected.to be_nil }
    end

    context "when operator_association_scope is specified" do
      let(:config) { { operator_association_scope: scope } }
      let(:scope) { proc { with_deleted } }

      it { is_expected.to eq scope }
    end
  end

  describe "#column_name_for" do
    subject { described_class.new(config).column_name_for(type) }

    context "when association names are not specified" do
      let(:config) { {} }

      context "when :creator is passed" do
        let(:type) { :creator }

        it { is_expected.to eq "created_by" }
      end

      context "when :updater is passed" do
        let(:type) { :updater }

        it { is_expected.to eq "updated_by" }
      end

      context "when :deleter is passed" do
        let(:type) { :deleter }

        it { is_expected.to eq "deleted_by" }
      end

      context "when :discarder is passed" do
        let(:type) { :discarder }

        it { is_expected.to eq "discarded_by" }
      end
    end

    context "when association names are specified" do
      let(:config) do
        {
          creator_column_name: "creator_operator_id",
          updater_column_name: "updater_operator_id",
          deleter_column_name: "deleter_operator_id",
          discarder_column_name: "discarder_operator_id"
        }
      end

      context "when :creator is passed" do
        let(:type) { :creator }

        it { is_expected.to eq "creator_operator_id" }
      end

      context "when :updater is passed" do
        let(:type) { :updater }

        it { is_expected.to eq "updater_operator_id" }
      end

      context "when :deleter is passed" do
        let(:type) { :deleter }

        it { is_expected.to eq "deleter_operator_id" }
      end

      context "when :discarder is passed" do
        let(:type) { :discarder }

        it { is_expected.to eq "discarder_operator_id" }
      end
    end
  end

  describe "#association_name_for" do
    subject { described_class.new(config).association_name_for(type) }

    context "when column names are not specified" do
      let(:config) { {} }

      context "when :creator is passed" do
        let(:type) { :creator }

        it { is_expected.to eq "creator" }
      end

      context "when :updater is passed" do
        let(:type) { :updater }

        it { is_expected.to eq "updater" }
      end

      context "when :deleter is passed" do
        let(:type) { :deleter }

        it { is_expected.to eq "deleter" }
      end

      context "when :discarder is passed" do
        let(:type) { :discarder }

        it { is_expected.to eq "discarder" }
      end
    end

    context "when column names are specified" do
      let(:config) do
        {
          creator_association_name: "creator_operator",
          updater_association_name: "updater_operator",
          deleter_association_name: "deleter_operator",
          discarder_association_name: "discarder_operator"
        }
      end

      context "when :creator is passed" do
        let(:type) { :creator }

        it { is_expected.to eq "creator_operator" }
      end

      context "when :updater is passed" do
        let(:type) { :updater }

        it { is_expected.to eq "updater_operator" }
      end

      context "when :deleter is passed" do
        let(:type) { :deleter }

        it { is_expected.to eq "deleter_operator" }
      end

      context "when :discarder is passed" do
        let(:type) { :discarder }

        it { is_expected.to eq "discarder_operator" }
      end
    end
  end
end
