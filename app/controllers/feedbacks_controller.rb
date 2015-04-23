class FeedbacksController < ApplicationController

  def new
    @feedback = current_user.feedback || Feedback.new
  end

  def create
    unless current_user.feedback.nil?
      current_user.feedback.destroy
    end
    @feedback = Feedback.new(feedback_params)
    @feedback.save
    @feedback.user = current_user
    flash.now[:notice] = 'Thank you for your feedback.'
    render :new
  end

  private
  def feedback_params
    params[:feedback]
  end
end
