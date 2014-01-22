module FeatureMacros
  def login_user
    user = create(:user)
    visit root_path
    click_button 'Log in'
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'Sign in'
  end

  def get_ticker_and_long_name(player)
    return "#{player.short_name} #{player.long_name}"
  end
end
