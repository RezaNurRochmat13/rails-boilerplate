# frozen_string_literal: true

class JsonWebToken # rubocop:disable Style/Documentation
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, JWT_SECRET_KEY, JWT_ALGORITHM)
    end

    def decode(token)
      decoded = JWT.decode(token, JWT_SECRET_KEY, true, { algorithm: JWT_ALGORITHM })[0]
      ActiveSupport::HashWithIndifferentAccess.new(decoded)
    rescue JWT::ExpiredSignature
      raise StandardError, 'Token has expired'
    rescue JWT::DecodeError
      raise StandardError, 'Invalid token'
    end
  end
end
