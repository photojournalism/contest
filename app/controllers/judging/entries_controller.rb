class Judging::EntriesController < ApplicationController

  before_action :require_admin
  layout "judging"

  def index
    get_shared_fields
  end

  def show
    @entry = Entry.where(:unique_hash => params[:hash]).first
    get_shared_fields(@entry.category)
  end

  private

  def get_shared_fields(category=nil)
    @contest = Contest.current
    @categories = @contest.categories
    @current_category = category ? category : (params[:category_id] ? Category.find(params[:category_id]) : @categories.first)
    @entries = Entry.where(:contest => @contest, :category => @current_category, :pending => false)
    @entries.each { |e| if !e.category_type.has_url && e.images.size == 0 then @entries.delete(e) end }
  end
end
