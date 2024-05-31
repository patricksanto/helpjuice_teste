FactoryBot.define do
  factory :search do
    query { "test query" }
    user_ip { "127.0.0.1" }
  end
end
