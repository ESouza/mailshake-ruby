# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mailshake::Leads do
  let(:leads) { described_class.new(Mailshake.client) }
  let(:base_url) { "https://api.mailshake.com/2017-04-01" }

  describe "#list" do
    it "lists leads" do
      stub_request(:get, "#{base_url}/leads/list")
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = leads.list
      expect(result["results"]).to eq([])
    end

    it "passes filter params" do
      stub_request(:get, "#{base_url}/leads/list")
        .with(query: { campaignID: "1", status: "open", perPage: "10" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      leads.list(campaign_id: "1", status: "open", per_page: "10")
    end
  end

  describe "#get" do
    it "gets a lead by id" do
      stub_request(:get, "#{base_url}/leads/get")
        .with(query: { leadID: "42" })
        .to_return(status: 200, body: { id: 42, status: "open" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = leads.get(lead_id: "42")
      expect(result["status"]).to eq("open")
    end
  end

  describe "#create" do
    it "creates leads" do
      stub_request(:post, "#{base_url}/leads/create")
        .with(body: { campaignID: 1, emailAddresses: ["john@example.com"] }.to_json)
        .to_return(status: 200, body: { results: [{ id: 1 }] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = leads.create(campaign_id: 1, email_addresses: ["john@example.com"])
      expect(result["results"].length).to eq(1)
    end
  end

  describe "#close" do
    it "closes a lead" do
      stub_request(:post, "#{base_url}/leads/close")
        .with(body: { leadID: 42, status: "won" }.to_json)
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      leads.close(lead_id: 42, status: "won")
    end
  end

  describe "#ignore" do
    it "ignores a lead" do
      stub_request(:post, "#{base_url}/leads/ignore")
        .with(body: { leadID: 42 }.to_json)
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      leads.ignore(lead_id: 42)
    end
  end

  describe "#reopen" do
    it "reopens a lead" do
      stub_request(:post, "#{base_url}/leads/reopen")
        .with(body: { leadID: 42 }.to_json)
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      leads.reopen(lead_id: 42)
    end
  end
end
