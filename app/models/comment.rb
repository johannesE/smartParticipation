class Comment
  include Neo4j::ActiveNode
  property :body, type: String
  property :pos_neg, type: Boolean

  property :created_at, type: DateTime
  # property :created_on, type: Date

  property :updated_at, type: DateTime
  # property :updated_on, type: Date

  # The following fields are redundant and only there for performance reasons
  property :standard_deviation, type: Float
  property :popularity, type: Float
  property :recommender_value, type: Float

  has_many :in, :ratings, unique: true, rel_class: Rating, model_class: User
  has_one :out, :article, type: :comment_on
  has_one :in, :author, unique: true, type: :authored, model_class: User

  has_many :out, :children, model_class: Comment, unique: true
  has_one :in, :child_of, model_class: Comment, unique: true, type: :children

  validates_length_of :body, within: 10..1000, too_long: ' is too long (max. 1000 letters)',
                      too_short: 'is too short. Provide more arguments please.'

  def get_number_of_replies
    result = 0
    unless children.count == 0
      result += children.count
      children.each do |child|
        result += child.get_number_of_replies
      end
    end
    result
  end

  # noinspection RubyInstanceMethodNamingConvention
  def get_standard_deviation_of_ratings
    comment_id = self.id
    query = Neo4j::Session.query.
        match("()-[rating:`rates`]->(this)").
        where("this.uuid = '#{comment_id}'").
        return("stdevp(rating.value)")
    self.standard_deviation =  query.first.first
  end

  def get_average_rating
    comment_id = self.id
    query = Neo4j::Session.query.
      match("()-[rating:`rates`]->(this)").
      where("this.uuid = '#{comment_id}'").
      return("avg(rating.value)")
    query.first.first
  end

  def get_popularity
    self.popularity = Math.log get_number_of_ratings, 10 # base = 10
  end

  def get_number_of_ratings(ratings = rels(type: :rates, dir: :incoming))
    ratings.count
  end

  def update_recommender_value
    self.recommender_value = self.get_popularity * self.get_standard_deviation_of_ratings
    self.save!
  end

end
