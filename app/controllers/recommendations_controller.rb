class RecommendationsController < ApplicationController
  def show
    @articles = Article.all.order(standard_deviation: :desc ).limit(20)
    @users = User.all.limit(20)
  end
end
