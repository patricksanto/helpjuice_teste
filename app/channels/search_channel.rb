class SearchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "search_channel"
    @last_query = nil
    @last_search_time = nil
  end

  def receive(data)
    query = data['query']
    user_ip = self.user_ip
    current_time = Time.current

    puts "_________________________________________________________________________________________"
    puts "Last search: #{@last_query}"
    puts "Current query: #{query}"
    puts "_________________________________________________________________________________________"

    if @last_search.nil? || @last_search != query
      @last_search = query
      @last_search_time = current_time

      SaveSearchJob.set(wait: 2.second).perform_later(query, user_ip, current_time)
    end

    results = Article.ransack(title_or_content_cont: query).result
    ActionCable.server.broadcast("search_channel", { results: results.as_json(only: [:title, :content]) })
  end
end
