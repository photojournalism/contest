class EntriesController < ApplicationController

  before_action :authenticate_user!

  def index
    @contest = Contest.current
    @completed_entries = current_user.completed_entries
    @pending_entries = current_user.pending_entries
    @managed_entries = current_user.managed_entries
  end

  def new
    @contest = Contest.current
    @categories = @contest.categories.order(:category_type_id => :asc, :id => :asc)
    @current_user = current_user

    if !@contest.has_started?
      flash.now[:notice] = t('contest.not_open', :contest => @contest, :open_date => @contest.formatted_open_date).html_safe
      return
    end

    if @contest.has_ended? && !current_user.admin
      flash.now[:notice] = t('contest.ended', :contest => @contest).html_safe
      return
    end

    if (!@contest.has_agreement_for?(current_user))
      session[:return_to] = request.fullpath
      redirect_to controller: 'agreements', action: 'new'
      return
    end
  end

  def create
    category = Category.find(entry_params[:category])
    user = current_user

    if entry_params[:user] && current_user.can_parent_others
      submitted_user = User.find(entry_params[:user])

      if submitted_user && submitted_user.user == current_user
        user = submitted_user
      end
    end

    entry = Entry.new(
      :user => user,
      :category => category,
      :unique_hash => SecureRandom.hex,
      :order_number => entry_params[:order_number],
      :judged => false,
      :contest => Contest.current,
      :pending => true
    )

    if entry.valid?
      entry.save
      render :json => { :url => edit_entry_path(entry.unique_hash) }
    else
      render :json => { :message => entry.errors }, :status => 500
    end
  end

  def edit
    @entry = Entry.where(:unique_hash => params[:hash]).first

    if !entry_is_modifiable(@entry)
      flash[:alert] = "An error has occurred processing your request. Please try again."
      redirect_to(:action => 'new')
    end
  end

  def confirmation
    @entry = Entry.where(:unique_hash => params[:hash]).first
    if !@entry.blank? && entry_access_is_allowed(@entry)
      if @entry.pending
        flash[:notice] = "This entry is currently not complete."
        redirect_to edit_entry_path(@entry.unique_hash)
      end
      return
    end
    redirect_to(:action => 'new')
  end

  def update
    @entry = Entry.where(:unique_hash => params[:hash]).first
    if entry_is_modifiable(@entry)
      @entry.pending = false
      if (params[:url])
        @entry.url = params[:url]
      end
      @entry.save
      render :json => { :message => "Successfully updated entry.", :url => entry_confirmation_path(@entry.unique_hash) }, :status => 200
      return
    end
    render :json => { :message => "This entry is no longer allowed to be updated." }, :status => 500
  end

  def destroy
    @entry = Entry.where(:unique_hash => params[:hash]).first
    if entry_is_modifiable(@entry)
      @entry.delete
      render :json => { :message => "Successfully deleted entry." }, :status => 200
      return
    end
    render :json => { :message => "This entry is no longer allowed to be updated." }, :status => 500
  end

  private

    def entry_is_modifiable(entry)
      return !entry.blank? && entry_access_is_allowed(entry) && (entry.contest.is_open? || current_user.admin || session[:previous_user])
    end

    def entry_access_is_allowed(entry)
      return (entry.user == current_user || entry.user.user == current_user || current_user.admin || session[:previous_user])
    end

    def entry_params
      params.require(:entry).permit(:user, :category, :order_number)
    end
end
