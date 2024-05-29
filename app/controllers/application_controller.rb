class ApplicationController < ActionController::Base
  before_action :set_ransack

  private

  def set_ransack
    @query  = Article.ransack(params[:q])
  end
end
