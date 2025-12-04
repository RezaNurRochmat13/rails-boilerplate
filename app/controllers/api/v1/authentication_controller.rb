# frozen_string_literal: true

module Api
  module V1
    class AuthController < ApplicationController # rubocop:disable Style/Documentation
      def login
        result = service.login(auth_params)
        render json: { message: 'success', data: result }, status: :ok
      end

      def register
        result = service.register(auth_params)
        render json: { message: 'success', data: result }, status: :created
      end

      private

      def service
        @service ||= AuthenticationService.new
      end

      def auth_params
        params.permit(:email, :password)
      end
    end
  end
end
