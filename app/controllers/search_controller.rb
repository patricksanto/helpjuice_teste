class SearchController < ApplicationController
  def index
    @query = Article.ransack(params[:q])
    @articles = @query.result(distinct: true)

    respond_to do |format|
      format.html
      format.json { render json: @articles }
    end
  end
end
