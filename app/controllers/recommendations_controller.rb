class RecommendationsController < ApplicationController
  def show
    # new users:
    @new_user_articles = Article.all.order(recommender_value: :desc ).limit(20)
    logger.info @new_user_articles

    #the following is only accurate for experienced users.
    @articles = Article.all.limit(20)

    user_id = current_user.id
    #  MATCH (n:User) <--> (m) <--> (user:User) WHERE (n <> m AND n.uuid = '8f4e7dd7-d047-427f-8540-7102ef008529') RETURN count(distinct m), user ORDER BY count(distinct m) DESC LIMIT {limit_21} | {"limit_21"=>21}
    result = Neo4j::Session.query.
        match("(n:User) <--> (m) <--> (user:User)").
        where("n <> m AND n.uuid = '#{user_id}'").
        return("count(distinct m), user").
        order("count(distinct m) DESC").
        limit(20)
    @users = result.to_a.collect{|r| r.user}

  end
end
