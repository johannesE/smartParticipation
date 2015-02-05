class Article
  include Neo4j::ActiveNode
  property :title, type: String
  property :body, type: String


  property :created_at, type: DateTime
  # property :created_on, type: Date

  property :updated_at, type: DateTime
  # property :updated_on, type: Date

  # defines a method for traversing incoming rated relationships from Article
  has_many :in, :ratings, unique: true, rel_class: Rating
  has_many :in, :comments, unique: true, type: :comment_on
  has_one :in, :user, unique:true, type: :authored
end
