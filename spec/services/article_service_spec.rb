require 'rails_helper'

RSpec.describe ArticleService, type: :service do
  let(:service) { described_class.new }
  let!(:article) { Article.create(title: 'Test Title', content: 'Test Content') }

  describe '#findAllArticle' do
    it 'returns all articles' do
      result = service.findAllArticle
      expect(result).to include(article)
    end

    it 'returns empty array when no articles exist' do
      Article.delete_all
      result = service.findAllArticle
      expect(result).to be_empty
    end
  end

  describe '#findArticleById' do
    it 'returns article by id' do
      result = service.findArticleById(article.id)
      expect(result).to eq(article)
    end

    it 'raises ActiveRecord::RecordNotFound when id not found' do
      expect { service.findArticleById(9999) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#createArticle' do
    let(:valid_params) { { title: 'New Article', content: 'Some content' } }

    it 'creates a new article with valid params' do
      result = service.createArticle(valid_params)
      expect(result).to be_persisted
      expect(result.title).to eq('New Article')
    end

    it 'fails to create article when params missing required fields' do
      result = service.createArticle({ title: nil, content: nil })
      expect(result).not_to be_persisted
      expect(result.errors).not_to be_empty
    end

    it 'ignores extra params not permitted by the model' do
      result = service.createArticle({ title: 'X', content: 'Y', unauthorized: 'Z' })
      expect(result.title).to eq('X')
      expect(result.content).to eq('Y')
      expect(result.attributes).not_to include('unauthorized')
    end
  end

  describe '#updateArticle' do
    let(:update_params) { { title: 'Updated Title', content: 'Updated Content' } }

    it 'updates article successfully' do
      result = service.updateArticle(article.id, update_params)
      expect(result.title).to eq('Updated Title')
      expect(result.content).to eq('Updated Content')
    end

    it 'does not update when params invalid' do
      result = service.updateArticle(article.id, { title: nil, content: nil })
      expect(result.errors).not_to be_empty
    end

    it 'raises ActiveRecord::RecordNotFound when id not found' do
      expect { service.updateArticle(9999, update_params) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#deleteArticle' do
    it 'deletes existing article' do
      expect { service.deleteArticle(article.id) }.to change(Article, :count).by(-1)
    end

    it 'raises ActiveRecord::RecordNotFound when deleting non-existent article' do
      expect { service.deleteArticle(9999) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'handles already destroyed article gracefully' do
      article.destroy
      expect { service.deleteArticle(article.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
