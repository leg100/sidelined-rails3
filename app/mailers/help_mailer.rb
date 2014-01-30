class HelpMailer < ActionMailer::Base

  def forward_message(help)
    @from = help[:email]
    @message = help[:message]
    mail(
      :from => 'support@sidelined.io',
      :to => 'support@sidelined.io', 
      :subject => 'help request from sidelined user')
  end
end
