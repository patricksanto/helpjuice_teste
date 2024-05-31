class SearchController < ApplicationController
  def index
    if params[:q]
      @articles = Article.ransack(params[:q]).result(distinct: true)
    else
      @articles = Article.all
    end
    @searches = Search.group(:query).order('count_all DESC').count(:all)
  end

  def perform_search
    query = params[:query]
    user_ip = request.remote_ip
    current_time = Time.current

    last_search = Search.where(user_ip: user_ip).order(created_at: :desc).first

    if last_search.nil? || last_search.query != query
      SaveSearchJob.perform_later(query, user_ip, current_time, last_search&.id) unless query.blank?
    end

    @articles = Article.ransack(title_or_content_cont: query).result(distinct: true)

    respond_to do |format|
      format.html { expires_now }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("searched_articles", partial: "articles/search_results", locals: { articles: @articles })
      end
    end
  end
end
