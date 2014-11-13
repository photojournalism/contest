class Judging::EntriesController < ApplicationController

  before_action :require_admin
  layout "judging"

  def index
    session[:hide_entries] == true if session[:hide_entries].nil?
    get_shared_fields
    if @current_category.category_type.maximum_files > 1
      redirect_to :action => 'show', :hash => @entries.first.unique_hash
      return
    end

    @images = []
    if @current_category.category_type.maximum_files == 1  
      @entries.each do |entry|
        @images << entry.images.first
      end
    end
  end

  def show
    @entry = Entry.where(:unique_hash => params[:hash]).first
    get_shared_fields(@entry.category)
  end

  def place
    entry = Entry.where(:unique_hash => params[:hash]).first
    place = Place.find(params[:id])
    if entry && place
      entry.place = place
      entry.save
      output = { :status => 'success' }
      if place.sequence_number == 99
        output[:next] = true
      end

      render :json => output
    else
      render :json => { :status => 'fail', :message => 'An error occurred. Please try again and notify an administrator if the issue persists.' }, :status => 400
    end
  end

  # Hides hidden entries
  def toggle_hidden_entries
    session[:hide_entries] = !session[:hide_entries]
    redirect_to request.referer
  end

  private

  def get_shared_fields(category=nil)
    @contest = Contest.current
    @categories = @contest.categories
    @current_category = category ? category : (params[:category_id] ? Category.find(params[:category_id]) : @categories.first)
    @entries = Entry.where(:contest => @contest, :category => @current_category, :pending => false).to_a.reject { |e| !e.category_type.has_url && e.images.size == 0 }.sort_by! { |e| e.unique_hash }
    @entries.reject! { |e| (e.place && e.place.sequence_number == 99 if session[:hide_entries]) || (e.place && e.place.name == 'Disqualified') } 
    @places = Place.all.sort_by { |p| p.sequence_number }
  end
end
