class ContactMailer < ActionMailer::Base

  def report_a_problem(user, message, browser)
    @user = user
    @message = message
    @browser = browser
    mail(:to => 'contest@photojournalism.org',
         :cc => 'webmaster@photojournalism.org',
         :subject => 'Contest Question or Issue Report',
         :reply_to => user.email)
  end

end
