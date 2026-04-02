# frozen_string_literal: true

module Mailshake
  module Models
    class Open < BaseModel
      has_one :recipient, Recipient
      has_one :campaign, Campaign
      has_one :parent, SentMessage
    end
  end
end
