class UsersController < ApplicationController

  before_filter :require_admin

  def index
    @users = User.all.order(:first_name)
  end

  def show
    @user = User.find(params[:id])
  end
end
