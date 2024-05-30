class SearchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "search_channel"
  end

  def receive(data)
    query = data['query']
    user_ip = self.user_ip
    current_time = Time.current

    last_search = Search.where(user_ip: user_ip).order(created_at: :desc).first

    if last_search.nil? || last_search.query != query
      SaveSearchJob.set(wait: 2.second).perform_later(query, user_ip, current_time, last_search&.id) unless query.blank?
    end

    results = Article.ransack(title_or_content_cont: query).result
    ActionCable.server.broadcast("search_channel", { results: results.as_json(only: [:title, :content]) })
  end
end
