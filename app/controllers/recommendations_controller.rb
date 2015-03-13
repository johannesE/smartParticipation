class RecommendationsController < ApplicationController
  def show
    # new users:
    @new_user_articles = Article.all.order(recommender_value: :desc ).limit(20)


    #the following is only accurate for experienced users.
    @articles = Article.all.limit(20)


    @users = User.all.limit(20)
  end
end
