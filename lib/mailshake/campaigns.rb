# frozen_string_literal: true

module Mailshake
  class Campaigns < Base
    def list(search: nil, next_token: nil, per_page: nil)
      response = client.get("/campaigns/list", camelize_params(search: search, next_token: next_token, per_page: per_page))
      Models::List.new(response, Models::Campaign)
    end

    def get(campaign_id:)
      response = client.get("/campaigns/get", camelize_params(campaign_id: campaign_id))
      Models::Campaign.new(response)
    end

    def create(title:, sender_id: nil)
      response = client.post("/campaigns/create", camelize_params(title: title, sender_id: sender_id))
      Models::Campaign.new(response)
    end

    def pause(campaign_id:)
      client.post("/campaigns/pause", camelize_params(campaign_id: campaign_id))
    end

    def unpause(campaign_id:)
      client.post("/campaigns/unpause", camelize_params(campaign_id: campaign_id))
    end

    def export(campaign_ids: nil, export_type: nil, timezone: nil)
      response = client.post("/campaigns/export", camelize_params(campaign_ids: campaign_ids, export_type: export_type, timezone: timezone))
      Models::CampaignExportRequest.new(response)
    end

    def export_status(status_id:)
      response = client.get("/campaigns/export-status", camelize_params(status_id: status_id))
      Models::CampaignExport.new(response)
    end
  end
end
