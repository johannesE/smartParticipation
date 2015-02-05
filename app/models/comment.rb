class Comment
  include Neo4j::ActiveNode
  property :body, type: String

  property :created_at, type: DateTime
  # property :created_on, type: Date

  property :updated_at, type: DateTime
  # property :updated_on, type: Date

  has_many :in, :users, unique: true, rel_class: Rating
  has_one :out, :articles, type: :comment_on

end
