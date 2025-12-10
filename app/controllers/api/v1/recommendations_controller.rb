# frozen_string_literal: true

module Api
  module V1
    class RecommendationsController < ApplicationController # rubocop:disable Style/Documentation
      def index
        user = current_user # atau load_user sesuai authentication Anda

        Rails.logger.info("[REQUEST] RecommendationsController#show user_id=#{user.id}")

        result = service.call(user)

        render json: {
          status: 'success',
          data: {
            engine: result[:engine],
            recommendations: result[:recommendations]
          }
        }, status: :ok
      end

      private

      # Dummy current_user; sesuaikan dengan Devise/JWT/Session Anda
      def current_user
        @current_user ||= User.find(params[:user_id])
      end

      def service
        @service = RecommendationService.new
      end
    end
  end
end
