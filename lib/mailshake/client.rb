# frozen_string_literal: true

require 'base64'

module Mailshake
  class Client
    include HTTParty

    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
      validate_configuration!
    end

    def get(path, params = {})
      request(:get, path, query: params)
    end

    def post(path, data = {})
      request(:post, path, body: data.to_json)
    end

    def me
      response = get("/me")
      Models::User.new(response)
    end

    private

    def validate_configuration!
      missing = configuration.missing_credentials
      raise ConfigurationError, missing unless missing.empty?
    end

    def request(method, path, options = {})
      url = "#{configuration.base_url}#{path}"
      request_options = {
        headers: auth_headers,
        timeout: configuration.timeout
      }

      if options[:query]
        request_options[:query] = options[:query]
      end

      if options[:body]
        request_options[:body] = options[:body]
        request_options[:headers] = request_options[:headers].merge('Content-Type' => 'application/json')
      end

      response = self.class.send(method, url, request_options)
      handle_response(response)
    end

    def auth_headers
      credentials = Base64.strict_encode64("#{configuration.api_key}:")
      {
        'Authorization' => "Basic #{credentials}",
        'Accept' => 'application/json'
      }
    end

    def handle_response(response)
      case response.code
      when 200, 201, 202, 204
        parsed = response.parsed_response
        check_for_limit_errors(parsed, response)
        parsed
      when 401
        raise AuthenticationError, "Authentication failed: #{response.body}"
      when 404
        raise NotFoundError.new("Resource not found", response.code, response.body)
      when 429
        retry_after = response.headers['retry-after']
        raise RateLimitError.new("Rate limit exceeded", response.code, response.body, retry_after)
      when 400, 422
        parsed = response.parsed_response || {}
        check_for_limit_errors(parsed, response)
        errors = parsed['errors'] || {}
        raise ValidationError.new(
          parsed['message'] || 'Validation failed',
          response.code,
          response.body,
          errors
        )
      when 500..599
        raise APIError.new("Server error", response.code, response.body)
      else
        raise APIError.new("Unexpected response", response.code, response.body)
      end
    end

    def check_for_limit_errors(parsed, response)
      return unless parsed.is_a?(Hash)

      error_code = parsed['error'] || parsed['errorCode']
      return unless error_code

      case error_code
      when 'limit_reached'
        retry_after = parsed['retryAfter']
        message = parsed['message'] || "Quota limit reached"
        raise LimitReachedError.new(message, response.code, response.body, retry_after)
      when 'exceeds_monthly_recipients'
        message = parsed['message'] || "Monthly recipient limit exceeded"
        raise MonthlyRecipientLimitError.new(message, response.code, response.body)
      end
    end
  end
end
