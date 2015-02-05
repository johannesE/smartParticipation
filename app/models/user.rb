class User 
  include Neo4j::ActiveNode
  property :name, type: String
  property :email, type: String

end
