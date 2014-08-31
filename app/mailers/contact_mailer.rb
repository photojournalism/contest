class ContactMailer < ActionMailer::Base

  def report_a_problem(user, message, browser)
    @user = user
    @message = message
    @browser = browser
    mail(:to => 'webmaster@photojournalism.org', :subject => 'A problem has been reported.')
  end

end
