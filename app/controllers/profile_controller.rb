class ProfileController < ApplicationController
  def update
    if user_params && current_user.update(user_params) && current_user.save
      notice = 'Profile updated successfully'
    else
      notice = 'Unable to save updates.'
    end

    redirect_to profile_path, notice: notice
  end

  def generate_public_link
    if current_user.update_public_token!
      notice = 'Public link generated successfully'
    else
      notice = 'There was an error generating your new token'
    end

    redirect_to profile_path, notice: notice
  end

  private

  def user_params
    if params[:user].present?
      params.require(:user).permit(:avatar)
    end
  end
end
