# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'API::V1::Authentication', type: :request do
  path '/api/v1/auth/register' do
    post 'Register new user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      security []

      parameter name: :params,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    email: { type: :string, format: :email },
                    password: { type: :string },
                    password_confirmation: { type: :string }
                  },
                  required: %w[name email password password_confirmation]
                }

      response '201', 'user created successfully' do
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: ['message']

        let(:params) do
          {
            name: 'John Doe',
            email: 'john@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        end

        run_test!
      end

      response '422', 'validation error' do
        let(:params) do
          {
            name: 'John Doe',
            email: '',
            password: 'password123',
            password_confirmation: 'password123'
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/auth/login' do
    post 'Login user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      security []

      parameter name: :params,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    email: { type: :string, format: :email },
                    password: { type: :string }
                  },
                  required: %w[email password]
                }

      response '200', 'login successful' do
        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     token: { type: :string }
                   },
                   required: ['token']
                 }
               }

        let!(:user) do
          User.create!(
            name: 'John Doe',
            email: 'john@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          )
        end

        let(:params) do
          {
            email: 'john@example.com',
            password: 'password123'
          }
        end

        run_test!
      end

      response '401', 'invalid credentials' do
        let!(:user) do
          User.create!(
            name: 'John Doe',
            email: 'john@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          )
        end

        let(:params) do
          {
            email: 'john@example.com',
            password: 'wrongpass'
          }
        end

        run_test!
      end
    end
  end
end
