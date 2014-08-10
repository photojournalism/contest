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

    if (@contest.has_agreement_for?(current_user))
      @categories = @contest.categories
    else
      session[:return_to] = request.fullpath
      redirect_to controller: 'agreements', action: 'new'
    end
  end
end
