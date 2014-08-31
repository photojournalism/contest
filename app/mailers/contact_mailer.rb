class ContactMailer < ActionMailer::Base

  def report_a_problem(user, message)
    @user = user
    @message = message
    @browser = Browser.new(:ua => "", :accept_language => "en-us")
    mail(:to => 'webmaster@photojournalism.org', :subject => 'A problem has been reported.')
  end

end
