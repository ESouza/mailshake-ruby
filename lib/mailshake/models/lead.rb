# frozen_string_literal: true

module Mailshake
  module Models
    class Lead < BaseModel
      has_one :recipient, Recipient
      has_one :campaign, Campaign
      has_one :assigned_to, User
    end
  end
end
