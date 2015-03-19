class Rating
  include Neo4j::ActiveRel
  after_save :update_recommendation_values


  property :value, type: Integer

  from_class User
  to_class :any
  type 'rates'

  property :created_at, type: DateTime
  # property :created_on, type: Date

  property :updated_at, type: DateTime
  # property :updated_on, type: Date

  def update_recommendation_values
    to_node.update_recommender_value
  end

end
