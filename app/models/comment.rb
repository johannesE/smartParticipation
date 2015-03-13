class Comment
  include Neo4j::ActiveNode
  property :body, type: String
  property :pos_neg, type: Boolean

  property :created_at, type: DateTime
  # property :created_on, type: Date

  property :updated_at, type: DateTime
  # property :updated_on, type: Date

  has_many :in, :ratings, unique: true, rel_class: Rating
  has_one :out, :article, type: :comment_on
  has_one :in, :author, unique: true, type: :authored, model_class: User

  has_many :out, :children, model_class: Comment, unique: true
  has_one :in, :child_of, model_class: Comment, unique: true, type: :children

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

  def update_recommender_value
    # TODO: include the comments in the recommendations and use this value.
  end

end
