class PeopleController < ApplicationController
  before_action :authenticate_user!

  def followers
    @followers = current_user.followers
    @pending_requests = current_user.pending_requests
  end

  def following
    @following = current_user.following

    @users = @following.clone.keep_if{ |x| x.last_known_location.present? }

    if @users.blank? && flash[:notice].blank?
      flash.now[:notice] = 'Nothing to see here. No location data yet.'
    end
  end

  def send_follow_request
    user_to_follow = User.find_by email: params[:people][:email]

    if user_to_follow.nil?
      flash[:notice] = "This user is not in the system"
    else
      follow_relation = FollowRelation.create(user: user_to_follow, follower: current_user, status: :pending)

      if follow_relation.valid?
        flash[:info] = "You've sent a request to follow #{user_to_follow.email}"
      else
        flash[:notice] = "Unable to send request to #{user_to_follow.email}}"
      end
    end

    redirect_to following_path
  end

  def accept_request
    follow_relation.active!

    redirect_to followers_path
  end

  def deny_request
    follow_relation.inactive!

    redirect_to followers_path
  end

  def follow_relation
    FollowRelation.find(params[:id])
  end
end
