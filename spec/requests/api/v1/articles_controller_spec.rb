require 'rails_helper'

RSpec.describe 'Api::V1::ArticlesController', type: :request do
  let!(:user) { User.create!(name: 'Test', email: 'test@mail.com', password: 'password') }
  let!(:token) { JwtUtil.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let!(:article) { Article.create!(title: 'Initial Title', content: 'Initial Content') }

  let(:valid_params) do
    {
      title: 'New Article',
      content: 'New Content'
    }
  end

  let(:invalid_params) do
    {
      title: nil,
      content: nil
    }
  end

  describe 'GET /api/v1/articles' do
    it 'returns all articles with status 200' do
      get '/api/v1/articles', headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('success')
      expect(json['data']).to be_an(Array)
      expect(json['data'].first['title']).to eq(article.title)
    end

    it 'returns empty array when no articles exist' do
      Article.delete_all
      get '/api/v1/articles', headers: headers

      json = JSON.parse(response.body)
      expect(json['data']).to eq([])
    end
  end

  describe 'GET /api/v1/articles/:id' do
    it 'returns article detail with status 200' do
      get "/api/v1/articles/#{article.id}", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['id']).to eq(article.id)
      expect(json['data']['title']).to eq('Initial Title')
    end

    it 'returns 404 when article not found' do
      get '/api/v1/articles/9999', headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/articles' do
    it 'creates article successfully with status 201' do
      post '/api/v1/articles', params: valid_params, headers: headers

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('success')
      expect(json['data']['title']).to eq('New Article')
    end

    it 'fails to create article with invalid params' do
      post '/api/v1/articles', params: invalid_params, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'PUT /api/v1/articles/:id' do
    it 'updates article successfully with status 200' do
      put "/api/v1/articles/#{article.id}",
          params: { title: 'Updated Title', content: 'Updated Content' },
          headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['title']).to eq('Updated Title')
    end

    it 'returns 404 when updating non-existent article' do
      put '/api/v1/articles/9999', params: valid_params, headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it 'returns error when params invalid' do
      put "/api/v1/articles/#{article.id}",
          params: invalid_params,
          headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'DELETE /api/v1/articles/:id' do
    it 'deletes article successfully with status 200' do
      delete "/api/v1/articles/#{article.id}", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('success')
    end

    it 'returns 404 when deleting non-existent article' do
      delete '/api/v1/articles/9999', headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
