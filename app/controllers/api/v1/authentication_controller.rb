# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApplicationController # rubocop:disable Style/Documentation
      def login
        result = service.login(auth_params)

        if result
          render json: { message: 'success', data: result }, status: :ok
        else
          render json: { message: 'invalid credentials' }, status: :unauthorized
        end
      end

      def register
        user = service.register(auth_params)

        if user.persisted?
          render json: { message: 'success', data: user }, status: :created
        else
          render json: { message: 'failed', errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def service
        @service ||= AuthenticationService.new
      end

      def auth_params
        params.permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
