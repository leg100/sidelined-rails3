class HelpMailer < ActionMailer::Base

  def forward_message(help)
    @from = help[:email]
    @message = help[:message]
    mail(
      :from => 'louisgarman@gmail.com',
      :to => 'louisgarman@gmail.com', 
      :subject => 'help request from sidelined user')
  end
end
