require 'spec_helper'

feature 'User management' do 
  scenario "login", js: true do
    login_user
  end

  scenario "sign up", js: true do
    expect {
      visit signup_path
      within '.signup-form' do
        fill_in 'signup_username', with: 'fanboy123'
        fill_in 'email', with: 'newuser@example.com'
        fill_in 'password', with: 'secret123'
        fill_in 'passwordConfirmation', with: 'secret123'
        click_button 'Sign up'
      end
      sleep 1
      page.should_not have_content "fanboy123 is logged in"
    }.to change(User, :count).by(1)

    open_email('newuser@example.com')
    current_email.default_part_body.to_s.should include('Confirm my account')
    visit_in_email('Confirm my account')
    URI.parse(current_url).request_uri == '/confirmed?status=successful'
#    page.should have_content "Successfully confirmed your signup"
  end
end
