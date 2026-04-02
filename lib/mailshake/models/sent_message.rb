# frozen_string_literal: true

module Mailshake
  module Models
    class SentMessage < BaseModel
      has_one :recipient, Recipient
      has_one :campaign, Campaign
      has_one :message, Message
    end
  end
end
