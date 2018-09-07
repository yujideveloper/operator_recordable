# frozen_string_literal: true

require "spec_helper"

RSpec.describe OperatorRecordable::ThreadStore do
  describe "#[]" do
    around do |example|
      Thread.current[:foo1] = "bar1"
      example.run
      Thread.current[:foo1] = nil
    end

    it { expect(described_class.new[:foo1]).to eq "bar1" }
  end

  describe "#[]=" do
    around do |example|
      described_class.new[:foo2] = "bar2"
      example.run
      Thread.current[:foo2] = nil
    end

    it { expect(Thread.current[:foo2]).to eq "bar2" }
  end
end
