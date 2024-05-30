class SearchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "search_channel"
  end

  def receive(data)
    query = data['query']
    user_ip = self.user_ip
    puts "User #{user_ip} searched for #{query}"
    Rails.logger.info("User #{user_ip} searched for #{query}")

    # Salvar a pesquisa no banco de dados
    Search.create(query: query, user_ip: user_ip)

    # Buscar resultados usando Ransack
    results = Article.ransack(title_or_content_cont: query).result

    # Transmitir os resultados de volta para o canal
    ActionCable.server.broadcast("search_channel", { results: results.as_json(only: [:title, :content]) })
  end
end
