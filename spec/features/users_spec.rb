require 'spec_helper'

feature 'User management' do 
  scenario "login", js: true do
    login_user
  end

  scenario "sign up", js: true do
    user = build(:user)
    expect {
      visit signup_path
      within '.signup-form' do
        fill_in 'signup_username', with: user.username
        fill_in 'email', with: user.email
        fill_in 'password', with: user.password
        fill_in 'passwordConfirmation', with: user.password_confirmation
        click_button 'Sign up'
      end
      sleep 1
      page.should_not have_content "#{user.username} is logged in"
    }.to change(User, :count).by(1)

    open_email(user.email)
    current_email.default_part_body.to_s.should include('Confirm my account')
    visit_in_email('Confirm my account')
    expect(URI.parse(current_url).request_uri).to eq('/confirmed?status=success')
    page.should have_content "Successfully confirmed your signup"
  end
end
