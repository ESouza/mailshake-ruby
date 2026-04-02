# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mailshake::Team do
  let(:team) { described_class.new(Mailshake.client) }
  let(:base_url) { "https://api.mailshake.com/2017-04-01" }

  describe "#list_members" do
    it "lists team members" do
      stub_request(:get, "#{base_url}/team/list-members")
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = team.list_members
      expect(result).to be_a(Mailshake::Models::List)
      expect(result.results).to eq([])
    end

    it "passes search and pagination params" do
      stub_request(:get, "#{base_url}/team/list-members")
        .with(query: { search: "john", perPage: "10" })
        .to_return(status: 200, body: { results: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      team.list_members(search: "john", per_page: "10")
    end
  end
end
