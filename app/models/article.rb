class Article
  include Neo4j::ActiveNode
  property :title, type: String
  property :body, type: String

  property :created_at, type: DateTime
  # property :created_on, type: Date

  property :updated_at, type: DateTime
  # property :updated_on, type: Date

  has_many :in, :ratings, unique: true, rel_class: Rating
  has_many :in, :comments, unique: true, type: :comment_on
  has_one :in, :author, unique: true, type: :authored, model_class: User
  has_one :out, :category, unique: true, model_class: Category

  def get_average_rating(ratings = rels(type: :rates, dir: :incoming))
    sum = 0
    number = 0
    ratings.each do |r|
      sum += r.value
      number += 1
    end
    if number == 0
      return 0
    end
    sum / number
  end

  def get_number_of_ratings(ratings = rels(type: :rates, dir: :incoming))
    ratings.count
  end

  # noinspection RubyInstanceMethodNamingConvention
  def get_standard_deviation_of_ratings
    ratings = rels(type: :rates, dir: :incoming)
    mean_rating = get_average_rating ratings
    square_difference = []
    ratings.each do |r|
      square_difference.append((mean_rating - r.value) ** 2)
    end
    result = 0
    square_difference.collect{ |s| result += s}
    result = result / get_number_of_ratings(ratings)
    Math.sqrt(result) # will be returned
  end

end
