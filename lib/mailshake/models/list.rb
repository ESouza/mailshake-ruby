# frozen_string_literal: true

module Mailshake
  module Models
    class List
      include Enumerable

      attr_reader :results, :next_token, :data

      def initialize(data, model_class)
        @data = data || {}
        raw_results = @data["results"] || []
        @results = raw_results.map { |item| item.is_a?(Hash) ? model_class.new(item) : item }
        @next_token = @data["nextToken"]
      end

      def each(&block)
        @results.each(&block)
      end

      def [](key)
        @data[key]
      end

      def to_h
        @data
      end
    end
  end
end
