# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.find_or_create_by(name: 'Aid')
Category.find_or_create_by(name: 'Arms Control')
Category.find_or_create_by(name: 'Climate Change')
Category.find_or_create_by(name: 'Consumption & Consumerism')
Category.find_or_create_by(name: 'Corporations')
Category.find_or_create_by(name: 'Criminal Court / Law')
Category.find_or_create_by(name: 'Economics & Trade')
Category.find_or_create_by(name: 'Environmental Issues')
Category.find_or_create_by(name: 'Food, Agriculture, Animals')
Category.find_or_create_by(name: 'Finances & Monetary Policy')
Category.find_or_create_by(name: 'Geopolitics')
Category.find_or_create_by(name: 'Health Issues')
Category.find_or_create_by(name: 'Migration, Human Population')
Category.find_or_create_by(name: 'Human Rights Issues')
Category.find_or_create_by(name: 'Thoughts & Conspiracy')
Category.find_or_create_by(name: 'Science')
Category.find_or_create_by(name: 'Political System')
Category.find_or_create_by(name: 'Political Organizations')
Category.find_or_create_by(name: 'Politicians')
Category.find_or_create_by(name: 'Poverty')
Category.find_or_create_by(name: 'Other')

# 1.times {
#   user1 = User.new
#   user1.email = 'test_email' + rand.to_s + "@mail.com"
#   user1.username = "testuser " + rand.to_s
#   user1.password = 'valid_password'
#   user1.password_confirmation = 'valid_password'
#   user1.save!
#   2.times{
#     article = Article.new(title: "test " + rand.to_s, body: "testBody")
#     article.save!
#     article.author = user1
#     15.times{
#       rating = rand(101)
#       rand_user = Neo4j::Session.query.match("(u:User)").with("u, rand() as r").return("u").order("r").limit(1).to_a.first.first
#       Rating.create(:value => rating,
#                     :from_node => rand_user, :to_node => article)
#     }
#
#   }
# }

