class RecommendationsController < ApplicationController
  def show
    # new users:
    @new_user_articles = Article.all.order(recommender_value: :desc ).limit(20)
    logger.info @new_user_articles

    #the following is only accurate for experienced users.
    @articles = Article.all.limit(20)

    user_id = current_user.id
    result = Neo4j::Session.query.
        match("(n:User) <--> (m) <--> (user:User)").
        where("n <> m AND n.uuid = '#{user_id}'").
        return("count(distinct m), user").
        order("count(distinct m) DESC").
        limit(20)
    users = result.to_a.collect{|r| r.user}
    @users = users

    # match (n:User) <--> (m) <--> (o:User) where n <> m return count(distinct m), o order by count(distinct m) DESC
  end
end
