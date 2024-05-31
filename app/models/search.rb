class Search < ApplicationRecord
  before_save :normalize_query

  validates :query, presence: true
  validates :user_ip, presence: true

  private

  def normalize_query
    self.query = query.strip.downcase
  end
end
