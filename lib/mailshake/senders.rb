# frozen_string_literal: true

module Mailshake
  class Senders < Base
    def list(search: nil, next_token: nil, per_page: nil)
      client.get("/senders/list", camelize_params(search: search, next_token: next_token, per_page: per_page))
    end
  end
end
