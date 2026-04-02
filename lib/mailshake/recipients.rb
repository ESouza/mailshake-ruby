# frozen_string_literal: true

module Mailshake
  class Recipients < Base
    def add(campaign_id:, addresses: nil, list_of_emails: nil, csv_data: nil, add_as_new_list: nil, truncate_extra_fields: nil)
      response = client.post("/recipients/add", camelize_params(
        campaign_id: campaign_id,
        addresses: addresses,
        list_of_emails: list_of_emails,
        csv_data: csv_data,
        add_as_new_list: add_as_new_list,
        truncate_extra_fields: truncate_extra_fields
      ))
      Models::AddRecipientsRequest.new(response)
    end

    def add_status(status_id:)
      response = client.get("/recipients/add-status", camelize_params(status_id: status_id))
      Models::AddedRecipients.new(response)
    end

    def list(campaign_id:, filter: nil, search: nil, next_token: nil, per_page: nil)
      response = client.get("/recipients/list", camelize_params(
        campaign_id: campaign_id,
        filter: filter,
        search: search,
        next_token: next_token,
        per_page: per_page
      ))
      Models::List.new(response, Models::Recipient)
    end

    def get(recipient_id: nil, campaign_id: nil, email_address: nil)
      response = client.get("/recipients/get", camelize_params(
        recipient_id: recipient_id,
        campaign_id: campaign_id,
        email_address: email_address
      ))
      Models::Recipient.new(response)
    end

    def pause(campaign_id:, email_address:)
      client.post("/recipients/pause", camelize_params(campaign_id: campaign_id, email_address: email_address))
    end

    def unpause(campaign_id:, email_address:)
      client.post("/recipients/unpause", camelize_params(campaign_id: campaign_id, email_address: email_address))
    end

    def unsubscribe(email_addresses:)
      client.post("/recipients/unsubscribe", camelize_params(email_addresses: email_addresses))
    end
  end
end
