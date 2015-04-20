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

  def get_average_rating
    article_id = self.id
    query = Neo4j::Session.query.
        match("()-[rating:`rates`]->(this)").
        where("this.uuid = '#{article_id}'").
        return("avg(rating.value)")
    query.first.first
  end

  def get_number_of_ratings(ratings = rels(type: :rates, dir: :incoming))
    ratings.count
  end

  # noinspection RubyInstanceMethodNamingConvention
  def get_standard_deviation_of_ratings
    article_id = self.id
    query = Neo4j::Session.query.
        match("()-[rating:`rates`]->(this)").
        where("this.uuid = '#{article_id}'").
        return("stdevp(rating.value)")
    self.standard_deviation =  query.first.first
  end

  def get_popularity
    self.popularity = Math.log get_number_of_ratings, 10 # base = 10
  end

  def update_recommender_value
    self.recommender_value = self.get_popularity * self.get_standard_deviation_of_ratings
    self.save!
  end

end
