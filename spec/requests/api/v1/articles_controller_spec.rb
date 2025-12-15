# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Api::V1::Articles', type: :request do
  let!(:user) { User.create!(name: 'Test', email: 'test@mail.com', password: 'password') }
  let!(:token) { JwtUtil.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  let!(:article) { Article.create!(title: 'Initial Title', content: 'Initial Content') }

  path '/api/v1/articles' do
    get 'List all articles' do
      tags 'Articles'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'articles retrieved' do
        schema type: :object,
               properties: {
                 message: { type: :string },
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       title: { type: :string },
                       content: { type: :string }
                     },
                     required: %w[id title content]
                   }
                 }
               }

        run_test!
      end
    end

    post 'Create article' do
      tags 'Articles'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :params,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    title: { type: :string },
                    content: { type: :string }
                  },
                  required: %w[title content]
                }

      response '201', 'article created' do
        let(:params) do
          {
            title: 'New Article',
            content: 'New Content'
          }
        end

        schema type: :object,
               properties: {
                 message: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     title: { type: :string },
                     content: { type: :string }
                   }
                 }
               }

        run_test!
      end

      response '422', 'invalid params' do
        let(:params) do
          {
            title: nil,
            content: nil
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/articles/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get article detail' do
      tags 'Articles'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'article found' do
        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     title: { type: :string },
                     content: { type: :string }
                   }
                 }
               }

        let(:id) { article.id }

        run_test!
      end

      response '404', 'article not found' do
        let(:id) { 9999 }

        run_test!
      end
    end

    put 'Update article' do
      tags 'Articles'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :params,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    title: { type: :string },
                    content: { type: :string }
                  }
                }

      response '200', 'article updated' do
        let(:id) { article.id }
        let(:params) do
          {
            title: 'Updated Title',
            content: 'Updated Content'
          }
        end

        run_test!
      end

      response '422', 'invalid params' do
        let(:id) { article.id }
        let(:params) do
          {
            title: nil,
            content: nil
          }
        end

        run_test!
      end

      response '404', 'article not found' do
        let(:id) { 9999 }
        let(:params) do
          {
            title: 'Updated Title',
            content: 'Updated Content'
          }
        end

        run_test!
      end
    end

    delete 'Delete article' do
      tags 'Articles'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'article deleted' do
        let(:id) { article.id }

        schema type: :object,
               properties: {
                 message: { type: :string }
               }

        run_test!
      end

      response '404', 'article not found' do
        let(:id) { 9999 }

        run_test!
      end
    end
  end
end
