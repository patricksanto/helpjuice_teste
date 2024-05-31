class SaveSearchJob < ApplicationJob
  queue_as :default


  def perform(query, user_ip, time_of_request, last_search_id = nil)
    normalized_query = normalize_query(query)

    last_search = Search.where(user_ip: user_ip).order(created_at: :desc).first
    time_diff = last_search ? time_of_request - last_search.created_at : nil

    if last_search.nil? || normalized_query != last_search.query || time_diff >= 4.seconds
      Search.create(query: normalized_query, user_ip: user_ip)
    else
      last_search.update(query: normalized_query, created_at: time_of_request)
    end
  end

  private

  def normalize_query(query)
    query.strip.downcase
  end
end
