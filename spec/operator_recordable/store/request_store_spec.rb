# frozen_string_literal: true

require "spec_helper"

RSpec.describe OperatorRecordable::RequestStore do
  before { ::RequestStore.clear! }

  describe "#[]" do
    before { ::RequestStore[:foo1] = "bar1" }

    it { expect(described_class.new[:foo1]).to eq "bar1" }
  end

  describe "#[]=" do
    before { described_class.new[:foo2] = "bar2" }

    it { expect(::RequestStore[:foo2]).to eq "bar2" }
  end
end
