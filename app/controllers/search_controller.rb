class SearchController < ApplicationController
  def index
    @query = Article.ransack(params[:q])
    @articles = @query.result
  end
end
