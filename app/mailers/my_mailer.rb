class MyMailer < Devise::Mailer   

  # eat my views!
  def confirmation_instructions(record, token, opts={})
    super
  end

  def reset_password_instructions(record, token, opts={})
    super
  end

  def unlock_instructions(record, token, opts={})
    super
  end
end
