# frozen_string_literal: true

module Mailshake
  class Leads < Base
    def list(campaign_id: nil, status: nil, assigned_to_email_address: nil, search: nil, next_token: nil, per_page: nil)
      response = client.get("/leads/list", camelize_params(
        campaign_id: campaign_id,
        status: status,
        assigned_to_email_address: assigned_to_email_address,
        search: search,
        next_token: next_token,
        per_page: per_page
      ))
      Models::List.new(response, Models::Lead)
    end

    def get(lead_id: nil, recipient_id: nil, campaign_id: nil, email_address: nil)
      response = client.get("/leads/get", camelize_params(
        lead_id: lead_id,
        recipient_id: recipient_id,
        campaign_id: campaign_id,
        email_address: email_address
      ))
      Models::Lead.new(response)
    end

    def create(campaign_id:, email_addresses: nil, recipient_ids: nil)
      response = client.post("/leads/create", camelize_params(
        campaign_id: campaign_id,
        email_addresses: email_addresses,
        recipient_ids: recipient_ids
      ))
      Models::CreatedLeads.new(response)
    end

    def close(lead_id: nil, campaign_id: nil, email_address: nil, recipient_id: nil, status: nil)
      client.post("/leads/close", camelize_params(
        lead_id: lead_id,
        campaign_id: campaign_id,
        email_address: email_address,
        recipient_id: recipient_id,
        status: status
      ))
    end

    def ignore(lead_id: nil, campaign_id: nil, email_address: nil, recipient_id: nil)
      client.post("/leads/ignore", camelize_params(
        lead_id: lead_id,
        campaign_id: campaign_id,
        email_address: email_address,
        recipient_id: recipient_id
      ))
    end

    def reopen(lead_id: nil, campaign_id: nil, email_address: nil, recipient_id: nil)
      client.post("/leads/reopen", camelize_params(
        lead_id: lead_id,
        campaign_id: campaign_id,
        email_address: email_address,
        recipient_id: recipient_id
      ))
    end
  end
end
