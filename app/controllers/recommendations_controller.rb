class RecommendationsController < ApplicationController
  def show
    unless user_signed_in?
      redirect_to new_user_session_path, notice: "You need to sign in to have access to personalized recommendations."
      return
    end
    # setup
    user_id = current_user.id

    # new users:
    @new_user_articles = Article.all.order(recommender_value: :desc ).limit(20)

    #the following is only accurate for experienced users.

    # Users with lots of interaction
    #  MATCH (n:User) <--> (m) <--> (user:User) WHERE (n <> m AND n.uuid = '8f4e7dd7-d047-427f-8540-7102ef008529') RETURN count(distinct m), user ORDER BY count(distinct m) DESC LIMIT {limit_21} | {"limit_21"=>21}
    interaction_query = Neo4j::Session.query.
        match("(me:User) <--> (m) <--> (other:User)").
        where("me <> m AND me <> other AND me.uuid = '#{user_id}'").
        return("count(distinct m) AS computed, other AS user").
        order("computed DESC").
        limit(10)
    @users = interaction_query.to_a

    # users with the same opinion (TODO: include the average rating of a user.)
    political_query = Neo4j::Session.query.
        match("(me:User) -[r1:`rates`]-> (a) <-[r2:`rates`]- (other:User)"). # m can be user or article.
        where("me <> other AND me.uuid = '#{user_id}'").
        with("(a.standard_deviation - ABS(r1.value - r2.value)) AS rating_diff, other"). # ABS() = absolute value in cypher
        return("other as user, sum(rating_diff) AS computed"). # other is the group key
        order("computed ASC"). # The weighted rating difference should be small
        limit(10)
    @political_users = political_query.to_a

    political_users = @political_users.collect{|po| po.user}
    other_ids = Array.new
    political_users.each do |u|
      other_ids << u.id # add the user id to the query
    end
    # unread articles from my favourite political users
    article_query =  Neo4j::Session.query.
        match("(me:User),(article) <-[r2:`rates`]- (other:User)").
        where("NOT (me) -- (article) AND me.uuid = '#{user_id}' AND other.uuid IN #{other_ids}").
        return("article, percentileCont(r2.value, 0.5) AS computed"). # percentileCont (x, 0.5 is the median)
        order("computed")

    @articles = article_query.to_a


  end
end
