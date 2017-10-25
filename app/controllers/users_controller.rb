class UsersController < ApplicationController

  def manage
    if current_user.can_parent_others
      @contest = Contest.current
      @users = current_user.users
    else
      render :nothing => true, :status => 404
    end
  end

  def add_child
    user = User.new(
      :first_name => params[:first_name],
      :last_name => params[:last_name],
      :email => SecureRandom.hex + '@fake.com',
      :password => SecureRandom.hex,
      :user => current_user,
      :employer => current_user.employer
    )
    if user.valid?
      user.save
      render :json => user
    else
      render :json => { :message => user.errors }, :status => 500
    end
  end
end
