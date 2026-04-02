# frozen_string_literal: true

module Mailshake
  class Error < StandardError; end

  class ConfigurationError < Error
    def initialize(missing_credentials)
      super("Missing required credentials: #{missing_credentials.join(', ')}")
    end
  end

  class AuthenticationError < Error
    def initialize(message = "Authentication failed")
      super(message)
    end
  end

  class APIError < Error
    attr_reader :status_code, :response_body

    def initialize(message, status_code = nil, response_body = nil)
      super(message)
      @status_code = status_code
      @response_body = response_body
    end
  end

  class ValidationError < APIError
    attr_reader :errors

    def initialize(message, status_code = nil, response_body = nil, errors = {})
      super(message, status_code, response_body)
      @errors = errors
    end
  end

  class NotFoundError < APIError
    def initialize(message = "Resource not found", status_code = 404, response_body = nil)
      super(message, status_code, response_body)
    end
  end

  class RateLimitError < APIError
    attr_reader :retry_after

    def initialize(message = "Rate limit exceeded", status_code = 429, response_body = nil, retry_after = nil)
      super(message, status_code, response_body)
      @retry_after = retry_after
    end
  end

  class LimitReachedError < APIError
    attr_reader :retry_after

    def initialize(message = "Quota limit reached", status_code = nil, response_body = nil, retry_after = nil)
      super(message, status_code, response_body)
      @retry_after = retry_after
    end
  end

  class MonthlyRecipientLimitError < APIError
    def initialize(message = "Monthly recipient limit exceeded", status_code = nil, response_body = nil)
      super(message, status_code, response_body)
    end
  end
end
