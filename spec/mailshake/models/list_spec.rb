# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mailshake::Models::List do
  describe "results array with model objects" do
    it "wraps results in model objects" do
      data = {
        "results" => [
          { "id" => 1, "title" => "Campaign 1" },
          { "id" => 2, "title" => "Campaign 2" }
        ],
        "nextToken" => "abc123"
      }

      list = described_class.new(data, Mailshake::Models::Campaign)
      expect(list.results.length).to eq(2)
      expect(list.results.first).to be_a(Mailshake::Models::Campaign)
      expect(list.results.first.title).to eq("Campaign 1")
      expect(list.results.last.title).to eq("Campaign 2")
    end

    it "handles empty results" do
      data = { "results" => [] }
      list = described_class.new(data, Mailshake::Models::Campaign)
      expect(list.results).to eq([])
    end

    it "handles missing results key" do
      list = described_class.new({}, Mailshake::Models::Campaign)
      expect(list.results).to eq([])
    end
  end

  describe "next_token" do
    it "exposes next_token from response" do
      data = { "results" => [], "nextToken" => "page2" }
      list = described_class.new(data, Mailshake::Models::Campaign)
      expect(list.next_token).to eq("page2")
    end

    it "returns nil when no next_token" do
      data = { "results" => [] }
      list = described_class.new(data, Mailshake::Models::Campaign)
      expect(list.next_token).to be_nil
    end
  end

  describe "Enumerable methods" do
    let(:data) do
      {
        "results" => [
          { "id" => 1, "title" => "First" },
          { "id" => 2, "title" => "Second" },
          { "id" => 3, "title" => "Third" }
        ]
      }
    end
    let(:list) { described_class.new(data, Mailshake::Models::Campaign) }

    it "supports each" do
      titles = []
      list.each { |campaign| titles << campaign.title }
      expect(titles).to eq(["First", "Second", "Third"])
    end

    it "supports map" do
      ids = list.map(&:id)
      expect(ids).to eq([1, 2, 3])
    end

    it "supports select" do
      selected = list.select { |c| c.id > 1 }
      expect(selected.length).to eq(2)
    end

    it "supports first" do
      expect(list.first).to be_a(Mailshake::Models::Campaign)
      expect(list.first.id).to eq(1)
    end

    it "supports count" do
      expect(list.count).to eq(3)
    end
  end

  describe "[] backwards compatibility" do
    it "accesses original hash keys" do
      data = { "results" => [{ "id" => 1 }], "nextToken" => "abc" }
      list = described_class.new(data, Mailshake::Models::Campaign)
      expect(list["results"]).to eq([{ "id" => 1 }])
      expect(list["nextToken"]).to eq("abc")
    end
  end

  describe "#to_h" do
    it "returns the original data hash" do
      data = { "results" => [{ "id" => 1 }], "nextToken" => "abc" }
      list = described_class.new(data, Mailshake::Models::Campaign)
      expect(list.to_h).to eq(data)
    end
  end
end
