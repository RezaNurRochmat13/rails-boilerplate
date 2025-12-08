# spec/requests/api/v1/auth_spec.rb
require 'rails_helper'

RSpec.describe 'API::V1', type: :request do
  let(:register_url) { '/api/v1/auth/register' }
  let(:login_url)    { '/api/v1/auth/login' }

  describe 'POST /register' do
    let(:valid_params) do
      {
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    end

    it 'creates a new user and returns 201' do
      post register_url, params: valid_params

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)

      expect(json['message']).to eq('success')
      expect(User.last.email).to eq('john@example.com')
    end

    it 'returns validation error when params invalid' do
      post register_url, params: valid_params.merge(email: '')

      expect(response.status).to eq(422).or eq(400)
    end
  end

  describe 'POST /login' do
    let!(:user) do
      User.create!(
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
    end

    it 'returns JWT token with valid credentials' do
      post login_url, params: { email: 'john@example.com', password: 'password123' }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json['data']['token']).to be_present
    end

    it 'returns unauthorized with invalid credentials' do
      post login_url, params: { email: 'john@example.com', password: 'wrongpass' }

      expect(response.status).to eq(401).or eq(400)
    end
  end
end
