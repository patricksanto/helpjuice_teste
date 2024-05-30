class SearchController < ApplicationController
  def index
    @searches = Search.group(:query).order('count_all DESC').count(:all)
  end
end
