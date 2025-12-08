# frozen_string_literal: true

class AuthenticationService # rubocop:disable Style/Documentation
  def login_user(auth_params)
    user = User.find_by(email: auth_params[:email])
    return nil unless user&.authenticate(auth_params[:password])

    JwtUtil.generate_token(user)
  end

  def register_user(user_params)
    @user = User.create(
      name: user_params[:name],
      email: user_params[:email],
      password: user_params[:password],
      password_confirmation: user_params[:password_confirmation]
    )

    @user
  end
end
