# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mailshake::Push do
  let(:push) { described_class.new(Mailshake.client) }
  let(:base_url) { "https://api.mailshake.com/2017-04-01" }

  describe "#create" do
    it "creates a push webhook" do
      stub_request(:post, "#{base_url}/push/create")
        .with(body: { targetUrl: "https://example.com/webhook", event: "reply" }.to_json)
        .to_return(status: 200, body: { id: 1 }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = push.create(target_url: "https://example.com/webhook", event: "reply")
      expect(result["id"]).to eq(1)
    end

    it "passes filter param" do
      stub_request(:post, "#{base_url}/push/create")
        .with(body: { targetUrl: "https://example.com/webhook", event: "reply", filter: { campaignID: 1 } }.to_json)
        .to_return(status: 200, body: { id: 1 }.to_json,
                   headers: { "Content-Type" => "application/json" })

      push.create(target_url: "https://example.com/webhook", event: "reply", filter: { campaignID: 1 })
    end
  end

  describe "#delete" do
    it "deletes a push webhook" do
      stub_request(:post, "#{base_url}/push/delete")
        .with(body: { targetUrl: "https://example.com/webhook" }.to_json)
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      push.delete(target_url: "https://example.com/webhook")
    end
  end
end
