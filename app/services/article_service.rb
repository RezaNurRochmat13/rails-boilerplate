# frozen_string_literal: true

class ArticleService
  def findAllArticle
    Article.all
  end

  def findArticleById(id)
    Article.find(id)
  end

  def createArticle(params)
    Article.create(title: params[:title], content: params[:content])
  end

  def updateArticle(id, params)
    article = findArticleById(id)
    article.update(title: params[:title], content: params[:content])

    article
  end

  def deleteArticle(id)
    article = findArticleById(id)
    article.destroy
  end
end
