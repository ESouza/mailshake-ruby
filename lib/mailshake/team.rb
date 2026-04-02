# frozen_string_literal: true

module Mailshake
  class Team < Base
    def list_members(search: nil, next_token: nil, per_page: nil)
      client.get("/team/list-members", camelize_params(search: search, next_token: next_token, per_page: per_page))
    end
  end
end
