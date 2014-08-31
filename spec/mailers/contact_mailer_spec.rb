require "rails_helper"

RSpec.describe ContactMailer, :type => :mailer do
  let(:user) { FactoryGirl.create(:user) }
  let(:browser) { Browser.new(:ua => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.94 Safari/537.36", :accept_language => "en-us") }
  let(:mail) { ContactMailer.report_a_problem(user, 'message', browser) }

  describe 'report_a_problem' do
    it 'renders the subject' do
      expect(mail.subject).to eq('A problem has been reported.')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(['webmaster@photojournalism.org'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@photojournalism.org'])
    end

    it 'assigns @user' do
      expect(mail.body.encoded).to match(user.full_name)
    end

    it 'assigns @browser' do
      expect(mail.body.encoded).to match(browser.name)
    end

    it 'assigns @message' do
      expect(mail.body.encoded).to match('message')
    end
  end
end
