class AgreementsController < ApplicationController
  
  before_action :authenticate_user!

  def new
    @contest = Contest.current
    @rules = @contest.contest_rules.text.html_safe
  end

  def create
    @contest = Contest.current
    @agreement = Agreement.create(:user => current_user, :contest => @contest)
    puts "Current User: #{current_user.first_name}"
    puts "Agreement: #{@agreement.user.first_name}"

    redirect_to(session[:return_to] || new_entry_path)
  end
end
