class ProfileController < ApplicationController
  def edit
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def own
    if user_signed_in?
      @profile = current_user.profile
      if @profile.nil? #First time the user wants to change his settings, so we have to create the object.
        profile = Profile.create use_recommendations: true #Default value
        profile.user = current_user
        @profile = profile
      end
    else
      redirect_to new_user_session_path
    end
    render :edit
  end

  def update
    @profile = Profile.find params[:id]
    unless @profile.user == current_user
      redirect_to redirect_to @profile, alert: 'You can only edit your own profile. Nice try though. :P'
    end
    respond_to do |format|
      if @profile.update(profile_params)

        disable_all_ratings @profile

        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end




  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit(:use_recommendations)
  end

  def disable_all_ratings(profile)
    user = profile.user
    user.ratings.each_rel.select do |rating|
      rating.usable = profile.use_recommendations
    end
  end

end
