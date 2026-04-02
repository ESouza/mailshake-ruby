# frozen_string_literal: true

module Mailshake
  module Models
    class Campaign < BaseModel
      has_one :sender, Sender
      has_many :messages, Message
    end
  end
end
