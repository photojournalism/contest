class Judging::EntriesController < ApplicationController

  before_action :require_admin
  layout "judging"

  def index
    session[:hide_entries] == true if session[:hide_entries].nil?
    session[:best_in_show] = false
    get_shared_fields
    @images = []
    if @entries.length == 0
      return
    end

    if @current_category.category_type.maximum_files > 1 && @current_category.name != 'Best in Show'
      redirect_to :action => 'show', :hash => @entries.first.unique_hash
      return
    end

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

  def clear_place
    entry = Entry.where(:unique_hash => params[:hash]).first
    entry.place = nil
    entry.save

    render :json => { :status => 'success' }
  end

  # Hides hidden entries
  def toggle_hidden_entries
    session[:hide_entries] = !session[:hide_entries]
    redirect_to request.referer
  end

  private

  def get_shared_fields(category=nil)
    @contest = Contest.current
    @categories = @contest.categories.order(:id)
    best_in_show = Category.where(:name => 'Best in Show').first
    @categories << best_in_show
    @current_category = category ? category : (params[:category_id] ? Category.find(params[:category_id]) : @categories.first)

    if @current_category.name == 'Best in Show' || session[:best_in_show] == true
      @current_category = best_in_show
      first_place = Place.where(:name => 'First Place').first
      @entries = Entry.where(:contest => @contest, :place => first_place).to_a.sort_by! { |e| e.unique_hash }
      @entries = [] if !@entries
      session[:best_in_show] = true
    else
      @entries = Entry.where(:contest => @contest, :category => @current_category, :pending => false).to_a.reject { |e| !e.category_type.has_url && e.images.size == 0 }.sort_by! { |e| e.unique_hash }
    end
    @entries.reject! { |e| (e.place && e.place.sequence_number == 99 if session[:hide_entries]) || (e.place && e.place.name == 'Disqualified') } 

    if @current_category.name == 'Best in Show' || session[:best_in_show] == true
      @places = []
    elsif @current_category.category_type.name == 'Portfolio'
      @places = Place.all.select { |p| p.sequence_number == 1 || p.sequence_number == 99 }
    else
      @places = Place.all.sort_by { |p| p.sequence_number }
    end

    get_counts
  end

  def get_counts
    total_entries = Entry.where(:contest => @contest, :category => @current_category, :pending => false)
    @total_entries_count = total_entries.size
    @out_entries_count = total_entries.to_a.reject { |e| (e.place && e.place.sequence_number != 99) || !e.place }.size
    @entries_left_count = Entry.where(:contest => @contest, :category => @current_category, :place => nil, :pending => false).size
  end
end
