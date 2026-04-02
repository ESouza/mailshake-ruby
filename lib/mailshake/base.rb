# frozen_string_literal: true

module Mailshake
  class Base
    attr_reader :client

    UPPERCASE_SUFFIXES = {
      "id" => "ID",
      "ids" => "IDs"
    }.freeze

    def initialize(client = nil)
      @client = client || Mailshake.client
    end

    private

    def camelize(key)
      parts = key.to_s.split('_')
      return parts[0] if parts.length == 1

      result = parts[0].dup
      parts[1..].each do |part|
        if UPPERCASE_SUFFIXES[part]
          result << UPPERCASE_SUFFIXES[part]
        else
          result << part.capitalize
        end
      end
      result
    end

    def camelize_params(params)
      params.each_with_object({}) do |(key, value), hash|
        hash[camelize(key)] = value unless value.nil?
      end
    end
  end
end
