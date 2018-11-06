class UsersController < ApplicationController

  before_action :authenticate_user!

  def impersonate
    if current_user.admin
      @user = User.find(params[:id])
      sign_in(@user)
      render :json => { :success => true, :user => @user }, :status => 200
    else
      render :nothing => true, :status => 404
    end
  end

  def manage
    if current_user.can_parent_others
      @contest = Contest.current
      @users = current_user.users
    else
      render :nothing => true, :status => 404
    end
  end

  def add_child
    if current_user.can_parent_others
      user = User.new(
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :email => SecureRandom.hex + '@fake.com',
        :password => SecureRandom.hex,
        :user => current_user,
        :employer => params[:employer]
      )
      if user.valid?
        user.save
        render :json => user
      else
        render :json => { :message => user.errors }, :status => 500
      end
    else
      render :nothing => true, :status => 404
    end
  end
end
