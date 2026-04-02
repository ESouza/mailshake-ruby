# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mailshake::Recipients do
  let(:recipients) { described_class.new(Mailshake.client) }
  let(:base_url) { "https://api.mailshake.com/2017-04-01" }

  describe "#add" do
    it "adds recipients to a campaign" do
      stub_request(:post, "#{base_url}/recipients/add")
        .with(body: { campaignID: 1, addresses: [{ emailAddress: "john@example.com" }] }.to_json)
        .to_return(status: 200, body: { statusID: 10 }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = recipients.add(campaign_id: 1, addresses: [{ emailAddress: "john@example.com" }])
      expect(result).to be_a(Mailshake::Models::AddRecipientsRequest)
      expect(result["statusID"]).to eq(10)
    end
  end

  describe "#add_status" do
    it "checks add status" do
      stub_request(:get, "#{base_url}/recipients/add-status")
        .with(query: { statusID: "10" })
        .to_return(status: 200, body: { isFinished: true }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = recipients.add_status(status_id: "10")
      expect(result).to be_a(Mailshake::Models::AddedRecipients)
      expect(result.is_finished).to be true
    end
  end

  describe "#list" do
    it "lists recipients for a campaign" do
      stub_request(:get, "#{base_url}/recipients/list")
        .with(query: { campaignID: "1" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = recipients.list(campaign_id: "1")
      expect(result).to be_a(Mailshake::Models::List)
      expect(result.results).to eq([])
    end

    it "passes filter and pagination params" do
      stub_request(:get, "#{base_url}/recipients/list")
        .with(query: { campaignID: "1", filter: "active", search: "john", perPage: "25" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      recipients.list(campaign_id: "1", filter: "active", search: "john", per_page: "25")
    end
  end

  describe "#get" do
    it "gets a recipient by id" do
      stub_request(:get, "#{base_url}/recipients/get")
        .with(query: { recipientID: "100" })
        .to_return(status: 200, body: { id: 100, emailAddress: "john@example.com" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = recipients.get(recipient_id: "100")
      expect(result).to be_a(Mailshake::Models::Recipient)
      expect(result.email_address).to eq("john@example.com")
    end
  end

  describe "#pause" do
    it "pauses a recipient" do
      stub_request(:post, "#{base_url}/recipients/pause")
        .with(body: { campaignID: 1, emailAddress: "john@example.com" }.to_json)
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      recipients.pause(campaign_id: 1, email_address: "john@example.com")
    end
  end

  describe "#unpause" do
    it "unpauses a recipient" do
      stub_request(:post, "#{base_url}/recipients/unpause")
        .with(body: { campaignID: 1, emailAddress: "john@example.com" }.to_json)
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      recipients.unpause(campaign_id: 1, email_address: "john@example.com")
    end
  end

  describe "#unsubscribe" do
    it "unsubscribes email addresses" do
      stub_request(:post, "#{base_url}/recipients/unsubscribe")
        .with(body: { emailAddresses: ["john@example.com"] }.to_json)
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      recipients.unsubscribe(email_addresses: ["john@example.com"])
    end
  end
end
