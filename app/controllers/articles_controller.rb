class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :mercury_update, :rate]
  before_action :verify_user, only: [:edit, :update, :mercury_update, :destroy, :create, :new]
  before_action :verify_author, only: [:edit, :update, :destroy, :mercury_update]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @comments = @article.comments
    @comment = Comment.new
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
    @comments = @article.comments
    @comment = Comment.new
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        @article.author = current_user
        @article.category = Category.find(params[:article][:category])

        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def mercury_update
    @article.title = params[:content][:article_title][:value]
    @article.body = params[:content][:article_body][:value]
    if @article.save
      render text: ''
    end
  end

  def rate
    rating = params[:articleRating]
    current_user.rels(type: :rates, between: @article).each { |rel| rel.destroy }
    Rating.create(:value => rating,
                  :from_node => current_user, :to_node => @article)
    render text: rating
  end

  def rate_comment
    rating = params[:comment_rating]
    comment = Comment.find(params[:comment_id])
    current_user.rels(type: :rates, between: comment).each { |rel| rel.destroy }
    Rating.create(:value => rating,
                  :from_node => current_user, :to_node => comment)
    render text: rating
  #   TODO: Fix the ajax success function. Render the form element and the comment id.
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit(:title, :body, :category)
  end

  def verify_author
    if @article.author == current_user
      true
    end
    false
  end

  def verify_user
    unless user_signed_in?
      redirect_to new_user_session_path
    end
    true
  end
end
