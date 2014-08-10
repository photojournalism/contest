class CategoriesController < ApplicationController

  before_filter :require_admin

  def index
    @categories = Category.all.order(:name)
  end
  
end
