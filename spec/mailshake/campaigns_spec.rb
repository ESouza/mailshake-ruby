# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mailshake::Campaigns do
  let(:campaigns) { described_class.new(Mailshake.client) }
  let(:base_url) { "https://api.mailshake.com/2017-04-01" }

  describe "#list" do
    it "lists campaigns" do
      stub_request(:get, "#{base_url}/campaigns/list")
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = campaigns.list
      expect(result).to be_a(Mailshake::Models::List)
      expect(result.results).to eq([])
    end

    it "passes search and pagination params" do
      stub_request(:get, "#{base_url}/campaigns/list")
        .with(query: { search: "test", nextToken: "abc", perPage: "10" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      campaigns.list(search: "test", next_token: "abc", per_page: "10")
    end
  end

  describe "#get" do
    it "gets a campaign by id" do
      stub_request(:get, "#{base_url}/campaigns/get")
        .with(query: { campaignID: "1" })
        .to_return(status: 200, body: { id: 1, title: "Test Campaign" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = campaigns.get(campaign_id: "1")
      expect(result).to be_a(Mailshake::Models::Campaign)
      expect(result.title).to eq("Test Campaign")
    end
  end

  describe "#create" do
    it "creates a campaign" do
      stub_request(:post, "#{base_url}/campaigns/create")
        .with(body: { title: "New Campaign", senderID: 5 }.to_json)
        .to_return(status: 200, body: { id: 2, title: "New Campaign" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = campaigns.create(title: "New Campaign", sender_id: 5)
      expect(result).to be_a(Mailshake::Models::Campaign)
      expect(result.title).to eq("New Campaign")
    end
  end

  describe "#pause" do
    it "pauses a campaign" do
      stub_request(:post, "#{base_url}/campaigns/pause")
        .with(body: { campaignID: 1 }.to_json)
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      campaigns.pause(campaign_id: 1)
    end
  end

  describe "#unpause" do
    it "unpauses a campaign" do
      stub_request(:post, "#{base_url}/campaigns/unpause")
        .with(body: { campaignID: 1 }.to_json)
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      campaigns.unpause(campaign_id: 1)
    end
  end

  describe "#export" do
    it "exports campaigns" do
      stub_request(:post, "#{base_url}/campaigns/export")
        .with(body: { campaignIDs: [1, 2], exportType: "csv", timezone: "US/Pacific" }.to_json)
        .to_return(status: 200, body: { statusID: 42 }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = campaigns.export(campaign_ids: [1, 2], export_type: "csv", timezone: "US/Pacific")
      expect(result).to be_a(Mailshake::Models::CampaignExportRequest)
      expect(result["statusID"]).to eq(42)
    end
  end

  describe "#export_status" do
    it "checks export status" do
      stub_request(:get, "#{base_url}/campaigns/export-status")
        .with(query: { statusID: "42" })
        .to_return(status: 200, body: { isFinished: true, csvDownloadUrl: "https://example.com/file.csv" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = campaigns.export_status(status_id: "42")
      expect(result).to be_a(Mailshake::Models::CampaignExport)
      expect(result.is_finished).to be true
      expect(result.csv_download_url).to eq("https://example.com/file.csv")
    end
  end
end
