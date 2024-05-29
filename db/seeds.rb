require 'faker'

# clean the database
Article.delete_all

# create 30 articles
# with fake data
puts "Creating 30 articles..."
30.times do
  Article.create(
    title: Faker::Book.title,
    content: Faker::Lorem.paragraph(sentence_count: 10)
  )
end

puts "Created 30 articles"
