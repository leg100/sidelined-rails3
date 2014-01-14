require 'spec_helper'

feature 'Search' do
  scenario "search for a player" do
    player = create(:player)
    visit root_path
    fill_in 'typeahead', with: player.short_name
    click_button 'Search'
    expect(page).to have_content player.long_name
  end
end
