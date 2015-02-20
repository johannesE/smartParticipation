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

  def get_average_rating
    sum = 0
    number = 0

    rels(type: :rates, dir: :incoming).each do |r|
      sum += r.value
      number += 1
    end
    if number == 0
      return 0
    end
    sum / number
  end

  def get_number_of_ratings
    rels(type: :rates, dir: :incoming).count
  end

end
