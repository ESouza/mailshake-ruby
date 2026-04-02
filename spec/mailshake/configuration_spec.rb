# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mailshake::Configuration do
  describe "#initialize" do
    it "sets default base_url" do
      config = described_class.new
      expect(config.base_url).to eq("https://api.mailshake.com/2017-04-01")
    end

    it "sets default timeout" do
      config = described_class.new
      expect(config.timeout).to eq(30)
    end
  end

  describe "#valid?" do
    it "returns true when api_key is set" do
      config = described_class.new
      config.api_key = "test_key"
      expect(config.valid?).to be true
    end

    it "returns false when api_key is nil" do
      config = described_class.new
      expect(config.valid?).to be false
    end

    it "returns false when api_key is empty" do
      config = described_class.new
      config.api_key = ""
      expect(config.valid?).to be false
    end
  end

  describe "#missing_credentials" do
    it "returns empty array when api_key is set" do
      config = described_class.new
      config.api_key = "test_key"
      expect(config.missing_credentials).to eq([])
    end

    it "returns api_key when missing" do
      config = described_class.new
      expect(config.missing_credentials).to eq(["api_key"])
    end
  end
end
