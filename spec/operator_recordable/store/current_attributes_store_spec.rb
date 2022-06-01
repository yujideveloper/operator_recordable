# frozen_string_literal: true

require "spec_helper"

RSpec.describe OperatorRecordable::CurrentAttributesStore do
  before { described_class::Current.reset }

  describe "#[]" do
    before { described_class::Current[:foo1] = "bar1" }

    it { expect(described_class.new[:foo1]).to eq "bar1" }
  end

  describe "#[]=" do
    before { described_class.new[:foo2] = "bar2" }

    it { expect(described_class::Current[:foo2]).to eq "bar2" }
  end
end
