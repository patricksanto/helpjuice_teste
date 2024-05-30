module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :user_ip

    def connect
      self.user_ip = request.remote_ip
    end
  end
end
