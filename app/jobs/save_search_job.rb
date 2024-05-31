class SaveSearchJob < ApplicationJob
  queue_as :default

  def perform(query, user_ip, time_of_request, last_search_id = nil)
    normalized_query = normalize_query(query)

    current_search = Search.find_by(id: last_search_id)
    time_diff = nil

    if current_search
      if normalized_query && current_search.query && (normalized_query.include?(current_search.query) || current_search.query.include?(normalized_query))
        time_diff = time_of_request - current_search.created_at

        if time_diff < 4.seconds
          current_search.update(query: normalized_query, created_at: time_of_request)
          return
        end
      end

      if time_diff.nil? || time_diff >= 4.seconds
        if normalized_query != current_search.query
          Search.create(query: normalized_query, user_ip: user_ip)
        end
      end
    else
      Search.create(query: normalized_query, user_ip: user_ip)
    end
  end

  private

  def normalize_query(query)
    query.strip.downcase
  end
end
