# frozen_string_literal: true

require "spec_helper"

RSpec.describe OperatorRecordable::Store do
  describe ".operator_store_key" do
    subject { described_class.operator_store_key }

    it { is_expected.to eq :operator_recordable_operator }
  end

  describe ".fetch_class" do
    subject { described_class.fetch_class(name) }

    context ":thread_store" do
      let(:name) { :thread_store }

      it { is_expected.to eq OperatorRecordable::ThreadStore }
    end

    context ":request_store" do
      let(:name) { :request_store }

      it { is_expected.to eq OperatorRecordable::RequestStore }
    end

    context ":current_attributes_store" do
      let(:name) { :current_attributes_store }

      it { is_expected.to eq OperatorRecordable::CurrentAttributesStore  }
    end

    context ":unknown_store" do
      let(:name) { :unknown_store }

      it { expect { subject }.to raise_error KeyError }
    end
  end
end