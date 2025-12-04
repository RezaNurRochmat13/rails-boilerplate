# frozen_string_literal: true

class AuthenticationService # rubocop:disable Style/Documentation
  def login_user(auth_params)
    user = User.find_by(email: auth_params[:email])
    user&.authenticate(auth_params[:password])

    generate_token
  end

  def register_user(user_params)
    @user = User.create(user_params)

    @user
  end

  private

  def generate_token
    @token = JsonWebToken.encode(user_id: user.id)
  end
end
