# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mailshake::Client do
  let(:client) { Mailshake.client }
  let(:base_url) { "https://api.mailshake.com/2017-04-01" }
  let(:expected_auth) { "Basic #{Base64.strict_encode64('test_api_key:')}" }

  describe "#initialize" do
    it "creates a client instance" do
      expect(client).to be_a(described_class)
    end

    context "with missing credentials" do
      it "raises a ConfigurationError" do
        config = Mailshake::Configuration.new
        expect { described_class.new(config) }.to raise_error(Mailshake::ConfigurationError)
      end
    end
  end

  describe "#get" do
    it "makes authenticated GET request" do
      stub_request(:get, "#{base_url}/test")
        .to_return(status: 200, body: { data: "ok" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = client.get("/test")
      expect(result).to eq("data" => "ok")
    end

    it "sends Basic auth header with base64 encoded api key" do
      stub_request(:get, "#{base_url}/test")
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      client.get("/test")
      expect(WebMock).to have_requested(:get, "#{base_url}/test")
        .with(headers: { "Authorization" => expected_auth })
    end

    it "sends Accept: application/json header" do
      stub_request(:get, "#{base_url}/test")
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      client.get("/test")
      expect(WebMock).to have_requested(:get, "#{base_url}/test")
        .with(headers: { "Accept" => "application/json" })
    end

    it "passes query parameters" do
      stub_request(:get, "#{base_url}/test")
        .with(query: { campaignID: "1", perPage: "10" })
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      client.get("/test", campaignID: "1", perPage: "10")
    end
  end

  describe "#post" do
    it "makes authenticated POST request with JSON body" do
      stub_request(:post, "#{base_url}/test")
        .with(body: { title: "Test" }.to_json,
              headers: { "Content-Type" => "application/json" })
        .to_return(status: 200, body: { id: 1 }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = client.post("/test", title: "Test")
      expect(result).to eq("id" => 1)
    end
  end

  describe "#me" do
    it "fetches the current user" do
      stub_request(:get, "#{base_url}/me")
        .to_return(status: 200, body: { teamID: 1, email: "test@example.com" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = client.me
      expect(result["email"]).to eq("test@example.com")
    end
  end

  describe "error handling" do
    it "raises AuthenticationError on 401" do
      stub_request(:get, "#{base_url}/expired")
        .to_return(status: 401, body: "Unauthorized")

      expect { client.get("/expired") }.to raise_error(Mailshake::AuthenticationError)
    end

    it "raises NotFoundError on 404" do
      stub_request(:get, "#{base_url}/missing")
        .to_return(status: 404, body: "Not Found")

      expect { client.get("/missing") }.to raise_error(Mailshake::NotFoundError)
    end

    it "raises RateLimitError on 429 with retry-after" do
      stub_request(:get, "#{base_url}/limited")
        .to_return(status: 429, body: "Too Many Requests",
                   headers: { "retry-after" => "30" })

      expect { client.get("/limited") }.to raise_error(Mailshake::RateLimitError) do |error|
        expect(error.retry_after).to eq("30")
      end
    end

    it "raises ValidationError on 400" do
      stub_request(:post, "#{base_url}/bad")
        .to_return(
          status: 400,
          body: { message: "Bad Request", errors: { "title" => ["is required"] } }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      expect { client.post("/bad", {}) }.to raise_error(Mailshake::ValidationError) do |error|
        expect(error.errors).to eq("title" => ["is required"])
      end
    end

    it "raises APIError on 500" do
      stub_request(:get, "#{base_url}/error")
        .to_return(status: 500, body: "Internal Server Error")

      expect { client.get("/error") }.to raise_error(Mailshake::APIError)
    end
  end
end
