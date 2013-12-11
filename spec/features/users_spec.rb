require 'spec_helper'

feature 'User management' do 
  scenario "login" do
    user = create(:user)
    visit root_path
    fill_in 'username', with: user.email
    fill_in 'password', with: user.password
    click_button 'Sign In'
    visit root_path
  end

  scenario "sign up" do
    expect {
      visit new_user_registration_path
      fill_in 'signup_username', with: 'fanboy123'
      fill_in 'signup_email', with: 'newuser@example.com'
      fill_in 'signup_password', with: 'secret123'
      fill_in 'signup_password_confirmation', with: 'secret123'
      click_button 'Sign up'
      visit root_path
    }.to change(User, :count).by(1)
  end
end
