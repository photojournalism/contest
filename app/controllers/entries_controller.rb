class EntriesController < ApplicationController

  def new
    @categories = Category.all.order(:name)
  end
end
