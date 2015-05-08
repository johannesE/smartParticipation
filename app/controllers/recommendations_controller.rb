class RecommendationsController < ApplicationController
  def show
    unless user_signed_in?
      redirect_to new_user_session_path, notice: "You need to sign in to have access to personalized recommendations."
      return
    end
    # setup
    user_id = current_user.id

    # new users:
    new_user_article_query = Neo4j::Session.query.match("(me:User), (a:Article)")
      .where("NOT (me)--(a) AND me.uuid = '#{user_id}'").return("a").order("a.recommender_value desc").limit(15)
    @new_user_articles = new_user_article_query.to_a.collect{|arr| arr.a}

    #the following is only accurate for experienced users.

    # Users with lots of interaction
    #  MATCH (n:User) <--> (m) <--> (user:User) WHERE (n <> m AND n.uuid = '8f4e7dd7-d047-427f-8540-7102ef008529') RETURN count(distinct m), user ORDER BY count(distinct m) DESC LIMIT {limit_21} | {"limit_21"=>21}
    interaction_query = Neo4j::Session.query.
        match("(me:User) <--> (m) <--> (other:User) <--> (profile:Profile)").
        where("me <> m AND me <> other AND me.uuid = '#{user_id}' AND profile.use_recommendations = true").
        return("count(distinct m) AS computed, other AS user").
        order("computed DESC").
        limit(5)
    @users = interaction_query.to_a

    # users with the same opinion (TODO: include the average rating of a user.)
    political_query = Neo4j::Session.query.
        match("(me:User) -[r1:`rates`]-> (a) <-[r2:`rates`]- (other:User) <--> (profile:Profile)").# m can be user or article.
        where("me <> other AND me.uuid = '#{user_id}' AND profile.use_recommendations = true").
        with("(a.standard_deviation - ABS(r1.value - r2.value)) AS rating_diff, other").# ABS() = absolute value in cypher
        return("other as user, sum(rating_diff) AS computed").# other is the group key
        order("computed ASC").# The weighted rating difference should be small
        limit(5)
    @political_users = political_query.to_a


    political_users = @political_users.collect { |po| po.user }
    other_ids = Array.new
    political_users.each do |u|
      other_ids << u.id # add the user id to the query
    end

    # unread articles from my favourite political users
    article_query = Neo4j::Session.query.
        match("(me:User),(article:Article) <-[r2:`rates`]- (other:User)").
        where("NOT (me) -- (article) AND me.uuid = '#{user_id}' AND other.uuid IN #{other_ids}").
        return("article, percentileCont(r2.value, 0.5) AS computed").# percentileCont (x, 0.5 is the median)
        order("computed desc").limit(20)
    @articles = article_query.to_a

    opinion_factor = current_user.profile.discussion_preference
    discussion_factor = (100 - opinion_factor) / 100 # /100 because otherwise the opinion is practically useless
    combination_user_query = Neo4j::Session.query.
      match("(me:User) -[r1:`rates`]-> (m) <-[r2:`rates`]- (other:User) <--> (profile:Profile)").
      where("me <> m AND me <> other AND me.uuid = '#{user_id}' AND profile.use_recommendations = true").
      with("(m.standard_deviation - ABS(r1.value - r2.value)) AS rating_diff, other, m").
      return("(#{discussion_factor} * sum(rating_diff) - #{opinion_factor} * count(distinct m)) AS computed, other AS user").
      order("computed ASC").
      limit(10)

    @combination_users = combination_user_query.to_a

  end
end
