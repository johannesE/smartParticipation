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
        match("(me:User) <--> (m) <--> (other:User)").
        where("me <> m AND me <> other AND me.uuid = '#{user_id}'").
        return("count(distinct m), other").
        order("count(distinct m) DESC").
        limit(10)
    @users = result.to_a.collect{|r| r.other}

    result = Neo4j::Session.query.
        match("(me:User) -[r1:`rates`]-> (m) <-[r2:`rates`]- (other:User)").
        where("me <> other AND me.uuid = '#{user_id}'").
        return("(ABS(r1.value - r2.value)), other"). # abs = absolute value in cypher
        order("(ABS(r1.value - r2.value)) DESC").
        limit(10)
    @political_users = result.to_a.collect{|r| r.other}

  end
end
