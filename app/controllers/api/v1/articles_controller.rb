# frozen_string_literal: true

module Api
  module V1
    class ArticlesController < ApplicationController
      before_action :authenticate!

      def index
        @articles = service.findAllArticle

        render json: {
          message: 'success',
          data: @articles
        }, status: :ok
      end

      def show
        @article = service.findArticleById(params[:id])

        render json: {
          message: 'success',
          data: @article
        }, status: :ok
      end

      def create
        @article = service.createArticle(article_params)

        render json: {
          message: 'success',
          data: @article
        }, status: :created
      end

      def update
        @article = service.updateArticle(params[:id], article_params)

        render json: {
          message: 'success',
          data: @article
        }, status: :ok
      end

      def destroy
        service.deleteArticle(params[:id])
        render json: {
          message: 'success'
        }, status: :ok
      end

      private

      def service
        @service ||= ArticleService.new
      end

      def article_params
        params.permit(:title, :content)
      end
    end
  end
end
