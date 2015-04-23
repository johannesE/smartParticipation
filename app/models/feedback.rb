class Feedback 
  include Neo4j::ActiveNode

  has_one :in, :user, unique: true, model_class: User, type: :feedback
  property :recommendation_rating, :type => Integer
  property :design_rating, :type => Integer
  property :functionality_rating, :type => Integer


end
