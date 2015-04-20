class RecommendationsController < ApplicationController
  def show
    # setup
    user_id = current_user.id

    # new users:
    @new_user_articles = Article.all.order(recommender_value: :desc ).limit(20)

    #the following is only accurate for experienced users.
    @articles = Article.all.limit(20)

    # Users with lots of interaction
    #  MATCH (n:User) <--> (m) <--> (user:User) WHERE (n <> m AND n.uuid = '8f4e7dd7-d047-427f-8540-7102ef008529') RETURN count(distinct m), user ORDER BY count(distinct m) DESC LIMIT {limit_21} | {"limit_21"=>21}
    result = Neo4j::Session.query.
        match("(me:User) <--> (m) <--> (other:User)").
        where("me <> m AND me <> other AND me.uuid = '#{user_id}'").
        return("count(distinct m), other").
        order("count(distinct m) DESC").
        limit(10)
    @users = result.to_a.collect{|r| r.other}

    # users with the same opinion
    result = Neo4j::Session.query.
        match("(me:User) -[r1:`rates`]-> (m) <-[r2:`rates`]- (other:User)").
        where("me <> other AND me.uuid = '#{user_id}'").
        with("(m.standard_deviation - ABS(r1.value - r2.value)) AS rating_diff, other"). # ABS() = absolute value in cypher
        return("other, sum(rating_diff)"). # other is the group key
        order("sum(rating_diff) ASC"). # The weighted rating difference should be small
        limit(10)
    @political_users = result.to_a.collect{|r| r.other}

  end
end
