# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mailshake::Models::BaseModel do
  describe "creating from hash with camelCase keys" do
    it "creates a model from a hash" do
      model = described_class.new("firstName" => "John", "lastName" => "Doe")
      expect(model.first_name).to eq("John")
      expect(model.last_name).to eq("Doe")
    end

    it "handles single-word keys" do
      model = described_class.new("id" => 42, "title" => "Test")
      expect(model.id).to eq(42)
      expect(model.title).to eq("Test")
    end

    it "handles keys with multiple capitals" do
      model = described_class.new("emailAddress" => "test@example.com", "teamID" => 5)
      expect(model.email_address).to eq("test@example.com")
      expect(model.team_id).to eq(5)
    end
  end

  describe "snake_case accessor methods" do
    it "defines accessor methods for all keys" do
      model = described_class.new("isArchived" => true, "createdDate" => "2026-01-01")
      expect(model.is_archived).to be true
      expect(model.created_date).to eq("2026-01-01")
    end

    it "responds to accessor methods" do
      model = described_class.new("firstName" => "John")
      expect(model.respond_to?(:first_name)).to be true
      expect(model.respond_to?(:nonexistent)).to be false
    end
  end

  describe "nested model hydration" do
    it "hydrates has_one associations" do
      campaign = Mailshake::Models::Campaign.new(
        "id" => 1,
        "title" => "Test",
        "sender" => { "id" => 10, "emailAddress" => "sender@example.com" }
      )
      expect(campaign.sender).to be_a(Mailshake::Models::Sender)
      expect(campaign.sender.id).to eq(10)
      expect(campaign.sender.email_address).to eq("sender@example.com")
    end

    it "hydrates has_many associations" do
      campaign = Mailshake::Models::Campaign.new(
        "id" => 1,
        "title" => "Test",
        "messages" => [
          { "id" => 1, "subject" => "Hello" },
          { "id" => 2, "subject" => "Follow up" }
        ]
      )
      expect(campaign.messages).to be_an(Array)
      expect(campaign.messages.length).to eq(2)
      expect(campaign.messages.first).to be_a(Mailshake::Models::Message)
      expect(campaign.messages.first.subject).to eq("Hello")
    end

    it "handles nil nested values" do
      campaign = Mailshake::Models::Campaign.new("id" => 1, "sender" => nil)
      expect(campaign.sender).to be_nil
    end

    it "handles deeply nested models" do
      lead = Mailshake::Models::Lead.new(
        "id" => 1,
        "campaign" => {
          "id" => 10,
          "sender" => { "id" => 20, "emailAddress" => "sender@example.com" }
        }
      )
      expect(lead.campaign).to be_a(Mailshake::Models::Campaign)
      expect(lead.campaign.sender).to be_a(Mailshake::Models::Sender)
      expect(lead.campaign.sender.email_address).to eq("sender@example.com")
    end
  end

  describe "[] backwards compatibility" do
    it "accesses original hash keys via []" do
      model = described_class.new("firstName" => "John", "emailAddress" => "john@example.com")
      expect(model["firstName"]).to eq("John")
      expect(model["emailAddress"]).to eq("john@example.com")
    end

    it "returns nil for missing keys" do
      model = described_class.new("id" => 1)
      expect(model["missing"]).to be_nil
    end
  end

  describe "#to_h" do
    it "returns the original hash" do
      data = { "id" => 1, "firstName" => "John", "emailAddress" => "john@example.com" }
      model = described_class.new(data)
      expect(model.to_h).to eq(data)
    end
  end

  describe "with empty hash" do
    it "handles empty hash" do
      model = described_class.new({})
      expect(model.to_h).to eq({})
    end

    it "handles nil" do
      model = described_class.new(nil)
      expect(model.to_h).to eq({})
    end
  end
end
