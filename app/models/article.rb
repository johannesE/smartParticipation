class Article
  include Neo4j::ActiveNode

  property :title, type: String
  property :body, type: String

  property :created_at, type: DateTime
  # property :created_on, type: Date

  property :updated_at, type: DateTime
  # property :updated_on, type: Date

  # The following fields are redundant and only there for performance reasons
  property :standard_deviation, type: Float
  property :popularity, type: Float
  property :recommender_value, type: Float

  has_many :in, :ratings, unique: true, rel_class: Rating, model_class: User
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
    # TODO: Standard Deviation Cipher (stdevp()) from http://neo4j.com/docs/2.2.0/query-aggregation.html
    ratings = rels(type: :rates, dir: :incoming)
    mean_rating = get_average_rating ratings
    square_difference = []
    ratings.each do |r|
      square_difference.append((mean_rating - r.value) ** 2)
    end
    variance = 0
    square_difference.collect{ |s| variance += s}
    variance = variance / get_number_of_ratings(ratings)
    self.standard_deviation = Math.sqrt(variance) # will be returned
  end

  def get_popularity
    self.popularity = Math.log get_number_of_ratings, 10 # base = 10
  end

  def update_recommender_value
    self.recommender_value = self.get_popularity * self.get_standard_deviation_of_ratings
    self.save!
  end

end
