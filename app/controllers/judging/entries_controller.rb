class Judging::EntriesController < ApplicationController

  layout "judging"

  def index
    @contest = Contest.current
    @categories = @contest.categories
    @current_category = params[:category_id] ? Category.find(params[:category_id]) : @categories.first
    @entries = Entry.where(:contest => @contest, :category => @current_category)
  end
end
