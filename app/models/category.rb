class Category 
  include Neo4j::ActiveNode

  property :name, type: String

  has_many :in, :articles, unique: true, model_class: Article
end
