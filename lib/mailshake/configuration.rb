# frozen_string_literal: true

module Mailshake
  class Configuration
    attr_accessor :api_key, :base_url, :timeout

    def initialize
      @base_url = "https://api.mailshake.com/2017-04-01"
      @timeout = 30
    end

    def valid?
      !api_key.nil? && !api_key.empty?
    end

    def missing_credentials
      missing = []
      missing << "api_key" if api_key.nil? || api_key.to_s.empty?
      missing
    end
  end
end
