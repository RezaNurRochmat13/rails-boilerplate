# frozen_string_literal: true

class ArticleService # rubocop:disable Style/Documentation
  CACHE_KEY_ALL = 'articles:all'
  CACHE_KEY_ID  = ->(id) { "articles:#{id}" }

  def findAllArticle
    Rails.cache.fetch(CACHE_KEY_ALL) do
      Article.all.to_a
    end
  end

  def findArticleById(id)
    Rails.cache.fetch(CACHE_KEY_ID.call(id)) do
      Article.find(id)
    end
  end

  def createArticle(params)
    article = Article.create(title: params[:title], content: params[:content])

    # invalidate cache
    Rails.cache.delete(CACHE_KEY_ALL)

    article
  end

  def updateArticle(id, params)
    article = findArticleById(id)
    article.update(title: params[:title], content: params[:content])

    # invalidate cache
    Rails.cache.delete(CACHE_KEY_ID.call(id))
    Rails.cache.delete(CACHE_KEY_ALL)

    article
  end

  def deleteArticle(id)
    article = findArticleById(id)
    article.destroy

    # invalidate cache
    Rails.cache.delete(CACHE_KEY_ID.call(id))
    Rails.cache.delete(CACHE_KEY_ALL)
  end
end
