# frozen_string_literal: true

module Mailshake
  class Push < Base
    def create(target_url:, event:, filter: nil)
      client.post("/push/create", camelize_params(target_url: target_url, event: event, filter: filter))
    end

    def delete(target_url:)
      client.post("/push/delete", camelize_params(target_url: target_url))
    end
  end
end
