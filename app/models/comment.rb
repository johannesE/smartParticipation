class Comment
  include Neo4j::ActiveNode
  property :body, type: String

  property :created_at, type: DateTime
  # property :created_on, type: Date

  property :updated_at, type: DateTime
  # property :updated_on, type: Date

  has_many :in, :users, unique: true, rel_class: Rating
  has_one :out, :article, type: :comment_on
  has_one :in, :author, unique: true, type: :authored, model_class: User

  has_many :both, :comments, model_class: Comment, unique: true

  def get_number_of_replies
    if comments.count == 0
      0
    else
      comments.count + comments.each.get_number_of_replies
    end
  end


end
