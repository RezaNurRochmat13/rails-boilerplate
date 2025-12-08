# frozen_string_literal: true

module Authenticable # rubocop:disable Style/Documentation
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
    attr_reader :current_user
  end

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?

    begin
      decoded = JwtUtil.decode(token)
      @current_user = User.find(decoded[:user_id])
    rescue StandardError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end
end
