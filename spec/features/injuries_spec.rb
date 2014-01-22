require 'spec_helper'

feature 'Injury management' do 
  background do
    login_user
    @player = create(:player)
  end

  scenario "add confirmed injury", js: true do
    expect {
      visit "/injuries/new"
      within '.form-container' do
        find("option[value='injured']").click
        fill_in 'player_typeahead', :with => get_ticker_and_long_name(@player)
        page.execute_script("$('#player_typeahead').trigger('focus');")
        page.execute_script ("$('#player_typeahead').trigger('keydown');")
        selector = "ul.dropdown-menu li a:first-of-type"
        page.should have_selector(selector)
        page.execute_script("$(\"#{selector}\").mouseenter().click()")
        page.should have_field('player_typeahead', :with => get_ticker_and_long_name(@player))

        fill_in 'player_body_part', :with => 'Calf'
        click_button 'Add'
      end
      sleep 1
    }.to change(Injury, :count).by(1)
  end

  scenario "edit injury", js: true do
    injury = create(:injury)
    player = injury.player
    expect {
      visit "/injuries/#{injury.id}/update"
      within '.form-container' do
        page.should have_field('player_typeahead', :with => get_ticker_and_long_name(player))
        fill_in 'player_body_part', :with => 'Thigh'
        click_button 'Update'
      end
      sleep 1
    }.to change(Injury, :count).by(0)
  end
end
