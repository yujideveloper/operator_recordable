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

      it { is_expected.to be_an_instance_of OperatorRecordable::RequestStore }
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

  describe "#operator_association_options" do
    subject { described_class.new(config).operator_association_options }

    context "when operator_association_options is not specified" do
      let(:config) { {} }

      it { is_expected.to match({}) }
    end

    context "when operator_association_options is specified" do
      let(:config) { { operator_association_options: { optional: true } } }

      it { is_expected.to match optional: true }
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
end
