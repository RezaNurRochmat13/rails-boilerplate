JWT_SECRET_KEY = Rails.application.credentials.jwt_secret || 'SECRET'
JWT_ALGORITHM  = 'HS256'
JWT_EXPIRATION = 2.weeks