class SaveSearchJob < ApplicationJob
  queue_as :default

  def perform(query, user_ip, time_of_request, last_search_id = nil)
    last_search = Search.find_by(id: last_search_id)
    time_diff = last_search ? time_of_request - last_search.created_at : nil

    if last_search.nil?
      Search.create(query: query, user_ip: user_ip)
      return
    end

    if (time_diff && time_diff >= 10.seconds)
      Search.create(query: query, user_ip: user_ip)
    else
      last_search.update(query: query, created_at: time_of_request)
    end
  end
end
