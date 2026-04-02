# frozen_string_literal: true

module Mailshake
  module Models
    class BaseModel
      class << self
        def has_one(field, klass)
          nested_one[field.to_s] = klass
        end

        def has_many(field, klass)
          nested_many[field.to_s] = klass
        end

        def nested_one
          @nested_one ||= {}
        end

        def nested_many
          @nested_many ||= {}
        end
      end

      attr_reader :data

      def initialize(data = {})
        @data = data || {}
        define_accessors
      end

      def [](key)
        @data[key]
      end

      def to_h
        @data
      end

      def respond_to_missing?(method_name, include_private = false)
        @accessors&.key?(method_name.to_s) || super
      end

      private

      def define_accessors
        @accessors = {}
        @data.each do |key, value|
          snake_key = underscore(key.to_s)
          hydrated = hydrate(snake_key, value)
          @accessors[snake_key] = hydrated

          define_singleton_method(snake_key) { @accessors[snake_key] }
        end
      end

      def hydrate(snake_key, value)
        one_klass = self.class.nested_one[snake_key]
        many_klass = self.class.nested_many[snake_key]

        if one_klass && value.is_a?(Hash)
          one_klass.new(value)
        elsif many_klass && value.is_a?(Array)
          value.map { |item| item.is_a?(Hash) ? many_klass.new(item) : item }
        else
          value
        end
      end

      def underscore(camel_cased_word)
        word = camel_cased_word.to_s.dup
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end
    end
  end
end
