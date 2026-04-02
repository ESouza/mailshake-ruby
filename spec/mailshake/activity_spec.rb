# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mailshake::Activity do
  let(:activity) { described_class.new(Mailshake.client) }
  let(:base_url) { "https://api.mailshake.com/2017-04-01" }

  describe "#sent" do
    it "lists sent messages" do
      stub_request(:get, "#{base_url}/activity/sent")
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = activity.sent
      expect(result).to be_a(Mailshake::Models::List)
      expect(result.results).to eq([])
    end

    it "passes campaign and pagination params" do
      stub_request(:get, "#{base_url}/activity/sent")
        .with(query: { campaignID: "1", perPage: "50" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      activity.sent(campaign_id: "1", per_page: "50")
    end
  end

  describe "#opens" do
    it "lists opens" do
      stub_request(:get, "#{base_url}/activity/opens")
        .with(query: { campaignID: "1", excludeDuplicates: "true" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = activity.opens(campaign_id: "1", exclude_duplicates: "true")
      expect(result).to be_a(Mailshake::Models::List)
      expect(result.results).to eq([])
    end
  end

  describe "#clicks" do
    it "lists clicks" do
      stub_request(:get, "#{base_url}/activity/clicks")
        .with(query: { campaignID: "1", matchUrl: "https://example.com" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      activity.clicks(campaign_id: "1", match_url: "https://example.com")
    end
  end

  describe "#replies" do
    it "lists replies" do
      stub_request(:get, "#{base_url}/activity/replies")
        .with(query: { campaignID: "1", replyType: "reply" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      activity.replies(campaign_id: "1", reply_type: "reply")
    end
  end

  describe "#created_leads" do
    it "lists created leads" do
      stub_request(:get, "#{base_url}/activity/created-leads")
        .with(query: { campaignID: "1", since: "2026-01-01" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      activity.created_leads(campaign_id: "1", since: "2026-01-01")
    end
  end

  describe "#lead_assignments" do
    it "lists lead assignments" do
      stub_request(:get, "#{base_url}/activity/lead-assignments")
        .with(query: { campaignID: "1" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      activity.lead_assignments(campaign_id: "1")
    end
  end

  describe "#lead_status_changes" do
    it "lists lead status changes" do
      stub_request(:get, "#{base_url}/activity/lead-status-changes")
        .with(query: { campaignID: "1", recipientEmailAddress: "john@example.com" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      activity.lead_status_changes(campaign_id: "1", recipient_email_address: "john@example.com")
    end
  end
end
