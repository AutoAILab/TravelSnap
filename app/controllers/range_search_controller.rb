class RangeSearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @following = current_user.following
  end

  def search
    @following = current_user.following

    @user = User.find_by email: params[:search][:email]

    @start_date = Date.new(
      params[:search][:start_date][:year].to_i,
      params[:search][:start_date][:month].to_i,
      params[:search][:start_date][:day].to_i)

    @end_date = Date.new(
      params[:search][:end_date][:year].to_i,
      params[:search][:end_date][:month].to_i,
      params[:search][:end_date][:day].to_i)

    @area = params[:search][:area]
    area_point = Geocoder.coordinates(@area)

    @distance = params[:search][:distance]

    @distance = is_number?(@distance) ? @distance : '1000'

    if current_user.following.include? @user
      if area_point.present?
        @locations = @user.locations
          .where(captured_at: @start_date.beginning_of_day..@end_date.end_of_day)
          .where("ST_Distance(location, 'POINT(#{area_point[1]} #{area_point[0]})') < #{@distance}")
      else
        @locations = @user.locations.where(captured_at: @start_date.beginning_of_day..@end_date.end_of_day)

        if @area.present?
          flash.now[:notice] = "Unable to geocode location #{@area}. Did not consider it in query."
        end
      end
    end

    if @locations.blank?
      flash.now[:notice] = 'Unable to find any locations for this query'
    end

    render 'index'
  end

  def is_number? val
    true if Float(val) rescue false
  end
end
