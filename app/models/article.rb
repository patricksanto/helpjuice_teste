class Article < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["content","id", "title"]
  end
  def self.ransackable_associations(auth_object = nil)
    []
  end
end
