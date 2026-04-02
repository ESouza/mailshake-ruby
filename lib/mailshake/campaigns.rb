# frozen_string_literal: true

module Mailshake
  class Campaigns < Base
    def list(search: nil, next_token: nil, per_page: nil)
      client.get("/campaigns/list", camelize_params(search: search, next_token: next_token, per_page: per_page))
    end

    def get(campaign_id:)
      client.get("/campaigns/get", camelize_params(campaign_id: campaign_id))
    end

    def create(title:, sender_id: nil)
      client.post("/campaigns/create", camelize_params(title: title, sender_id: sender_id))
    end

    def pause(campaign_id:)
      client.post("/campaigns/pause", camelize_params(campaign_id: campaign_id))
    end

    def unpause(campaign_id:)
      client.post("/campaigns/unpause", camelize_params(campaign_id: campaign_id))
    end

    def export(campaign_ids: nil, export_type: nil, timezone: nil)
      client.post("/campaigns/export", camelize_params(campaign_ids: campaign_ids, export_type: export_type, timezone: timezone))
    end

    def export_status(status_id:)
      client.get("/campaigns/export-status", camelize_params(status_id: status_id))
    end
  end
end
