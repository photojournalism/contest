class EntriesController < ApplicationController

  before_action :authenticate_user!

  def new
    @contest = Contest.current

    if !@contest.has_started?
      flash.now[:notice] = t('contest.not_open', :contest => @contest, :open_date => @contest.formatted_open_date).html_safe
      return
    elsif @contest.has_ended?
      flash.now[:notice] = t('contest.ended', :contest => @contest).html_safe
      return
    end

    if (!@contest.has_agreement_for?(current_user))
      session[:return_to] = request.fullpath
      redirect_to controller: 'agreements', action: 'new'
      return
    end
    
    @categories = @contest.categories
  end

  def create
    category = Category.find(entry_params[:category])
    entry = Entry.new(
      :user => current_user,
      :category => category,
      :unique_hash => SecureRandom.hex,
      :order_number => entry_params[:order_number],
      :judged => false,
      :contest => Contest.current
    )

    if entry.valid?
      entry.save
      render :json => { :url => "/entries/#{entry.unique_hash}" }
    else
      render :json => { :message => entry.errors }, :status => 500
    end
  end

  def show
    logger.debug "Looking up entry with hash: #{params[:hash]}"
    @entry = Entry.where(:unique_hash => params[:hash]).first
    if @entry.blank?
      logger.debug "Entry wasn't found. Redirecting..."
      redirect_to(:action => 'new')
      return
    end

    if @entry.user != current_user
      flash[:alert] = "An error has occurred processing your request. Please try again."
      redirect_to(:action => 'new')
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:category, :order_number)
  end
end
