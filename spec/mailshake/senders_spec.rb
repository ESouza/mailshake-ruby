# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mailshake::Senders do
  let(:senders) { described_class.new(Mailshake.client) }
  let(:base_url) { "https://api.mailshake.com/2017-04-01" }

  describe "#list" do
    it "lists senders" do
      stub_request(:get, "#{base_url}/senders/list")
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = senders.list
      expect(result).to be_a(Mailshake::Models::List)
      expect(result.results).to eq([])
    end

    it "passes search and pagination params" do
      stub_request(:get, "#{base_url}/senders/list")
        .with(query: { search: "sales", perPage: "10" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      senders.list(search: "sales", per_page: "10")
    end
  end
end
