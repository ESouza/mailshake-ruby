# frozen_string_literal: true

module Mailshake
  class Activity < Base
    def sent(message_type: nil, campaign_message_type: nil, campaign_id: nil, recipient_email_address: nil, exclude_body: nil, next_token: nil, per_page: nil)
      response = client.get("/activity/sent", camelize_params(
        message_type: message_type,
        campaign_message_type: campaign_message_type,
        campaign_id: campaign_id,
        recipient_email_address: recipient_email_address,
        exclude_body: exclude_body,
        next_token: next_token,
        per_page: per_page
      ))
      Models::List.new(response, Models::SentMessage)
    end

    def opens(campaign_id: nil, exclude_duplicates: nil, recipient_email_address: nil, next_token: nil, per_page: nil, since: nil)
      response = client.get("/activity/opens", camelize_params(
        campaign_id: campaign_id,
        exclude_duplicates: exclude_duplicates,
        recipient_email_address: recipient_email_address,
        next_token: next_token,
        per_page: per_page,
        since: since
      ))
      Models::List.new(response, Models::Open)
    end

    def clicks(campaign_id: nil, exclude_duplicates: nil, match_url: nil, recipient_email_address: nil, next_token: nil, per_page: nil, since: nil)
      response = client.get("/activity/clicks", camelize_params(
        campaign_id: campaign_id,
        exclude_duplicates: exclude_duplicates,
        match_url: match_url,
        recipient_email_address: recipient_email_address,
        next_token: next_token,
        per_page: per_page,
        since: since
      ))
      Models::List.new(response, Models::Click)
    end

    def replies(reply_type: nil, campaign_id: nil, recipient_email_address: nil, next_token: nil, per_page: nil)
      response = client.get("/activity/replies", camelize_params(
        reply_type: reply_type,
        campaign_id: campaign_id,
        recipient_email_address: recipient_email_address,
        next_token: next_token,
        per_page: per_page
      ))
      Models::List.new(response, Models::Reply)
    end

    def created_leads(campaign_id: nil, recipient_email_address: nil, assigned_to_email_address: nil, next_token: nil, per_page: nil, since: nil)
      response = client.get("/activity/created-leads", camelize_params(
        campaign_id: campaign_id,
        recipient_email_address: recipient_email_address,
        assigned_to_email_address: assigned_to_email_address,
        next_token: next_token,
        per_page: per_page,
        since: since
      ))
      Models::List.new(response, Models::Lead)
    end

    def lead_assignments(campaign_id: nil, next_token: nil, per_page: nil, since: nil)
      response = client.get("/activity/lead-assignments", camelize_params(
        campaign_id: campaign_id,
        next_token: next_token,
        per_page: per_page,
        since: since
      ))
      Models::List.new(response, Models::Lead)
    end

    def lead_status_changes(campaign_id: nil, recipient_email_address: nil, assigned_to_email_address: nil, next_token: nil, per_page: nil, since: nil)
      response = client.get("/activity/lead-status-changes", camelize_params(
        campaign_id: campaign_id,
        recipient_email_address: recipient_email_address,
        assigned_to_email_address: assigned_to_email_address,
        next_token: next_token,
        per_page: per_page,
        since: since
      ))
      Models::List.new(response, Models::LeadStatus)
    end
  end
end
