class ContactController < ApplicationController

  before_action :authenticate_user!

  def report_a_problem
    if params[:message]
      browser = Browser.new(:ua => request.headers["User-Agent"], :accept_language => "en-us")
      ContactMailer.report_a_problem(current_user, params[:message], browser).deliver
      render :json => { :message => 'Successfully delivered message.' }, :status => 200
    else
      render :json => { :message => 'Reporting a problem requires a message parameter.' }, :status => 400
    end
  end
end
