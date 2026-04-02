# frozen_string_literal: true

require 'httparty'
require 'json'

require_relative 'mailshake/version'
require_relative 'mailshake/errors'
require_relative 'mailshake/configuration'
require_relative 'mailshake/client'
require_relative 'mailshake/base'
require_relative 'mailshake/campaigns'
require_relative 'mailshake/recipients'
require_relative 'mailshake/activity'
require_relative 'mailshake/leads'
require_relative 'mailshake/team'
require_relative 'mailshake/senders'
require_relative 'mailshake/push'

module Mailshake
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    def client
      @client ||= Client.new(configuration)
    end

    def reset!
      @client = nil
      @configuration = nil
    end
  end
end
