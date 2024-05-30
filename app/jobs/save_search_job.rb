class SaveSearchJob < ApplicationJob
  queue_as :default

  def perform(query, user_ip, time_of_request)
    current_search = Search.where(user_ip: user_ip).order(created_at: :desc).first

    if current_search && (query.include?(current_search.query) || current_search.query.include?(query))
      current_search.update(query: query, created_at: time_of_request)
      return
    end

    if current_search.nil? || (current_search.created_at < time_of_request && query != current_search.query)
      Search.create(query: query, user_ip: user_ip)
    end
  end
end
