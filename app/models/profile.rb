class Profile 
  include Neo4j::ActiveNode

  property :created_at, type: DateTime
  # property :created_on, type: Date

  property :updated_at, type: DateTime
  # property :updated_on, type: Date

  property :use_recommendations, type: Boolean
  property :can_be_contacted, type: Boolean
  property :discussion_preference, type: Float

  has_one :in, :user, type: :profile_of, unique: true, model_class: User


end
