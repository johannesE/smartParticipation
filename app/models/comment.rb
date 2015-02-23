class Comment
  include Neo4j::ActiveNode
  property :body, type: String

  property :created_at, type: DateTime
  # property :created_on, type: Date

  property :updated_at, type: DateTime
  # property :updated_on, type: Date

  has_many :in, :ratings, unique: true, rel_class: Rating
  has_one :out, :article, type: :comment_on
  has_one :in, :author, unique: true, type: :authored, model_class: User

  has_many :out, :children, model_class: Comment, unique: true
  has_one :in, :child_of, model_class: Comment, unique: true

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


end
