require 'spec_helper'

feature 'Help management' do 
  scenario "send help message", js: true do
    visit '/help'
    within '#help-form' do
      fill_in 'email', with: 'newuser@example.com'
      fill_in 'message', with: 'help me'
      click_button 'Send'
    end
    sleep 1
    expect(open_last_email).to have_subject 'help request from sidelined user'
    expect(open_last_email).to have_content 'Help request from newuser@example.com'
  end
end
