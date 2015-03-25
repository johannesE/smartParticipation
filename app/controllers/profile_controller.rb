class ProfileController < ApplicationController
  def index
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
  end
end
