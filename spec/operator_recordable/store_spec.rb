# frozen_string_literal: true

require "spec_helper"

RSpec.describe OperatorRecordable::Store do
  describe ".fetch" do
    subject { described_class.fetch(name) }

    context "when :thread_store is passed" do
      let(:name) { :thread_store }

      it { is_expected.to eq OperatorRecordable::ThreadStore }
    end

    context "when :request_store is passed" do
      let(:name) { :request_store }

      if defined? ::RequestStore
        it { is_expected.to eq OperatorRecordable::RequestStore }
      else
        it { expect { subject }.to raise_error KeyError }
      end
    end

    context "when :current_attributes_store is passed" do
      let(:name) { :current_attributes_store }

      if defined? ::ActiveSupport::CurrentAttributes
        it { is_expected.to eq OperatorRecordable::CurrentAttributesStore }
      else
        it { expect { subject }.to raise_error KeyError }
      end
    end

    context "when :unknown_store is passed" do
      let(:name) { :unknown_store }

      it { expect { subject }.to raise_error KeyError }
    end
  end
end
