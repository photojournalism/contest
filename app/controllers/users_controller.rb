class UsersController < ApplicationController

  before_filter :require_admin

  def index
    @users = User.all
  end
end
