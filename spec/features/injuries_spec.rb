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

    expect(page.current_path).to eq("/injuries/#{Injury.last.id}")
  end

  scenario "edit injury", js: true do
    injury = create(:injury)
    expect(injury.version).to eq(1)

    expect {
      visit "/injuries/#{injury.id}/update"
      within '.form-container' do
        page.should have_field('player_typeahead', :with => get_ticker_and_long_name(injury.player))
        fill_in 'player_body_part', :with => 'Thigh'
        click_button 'Update'
      end
      sleep 1
    }.to change(HistoryTracker, :count).by(1)
    
    injury.reload
    expect(injury.version).to eq(2)
  end

  scenario "add injury via bookmarklet", js: true do
    expect {
      visit "/views/bookmarklet/test.html"
      uri = URI.parse(current_url)

      within_frame 'sidelinedIFrame' do
        within '.form-container' do
          find("option[value='injured']").click
          fill_in 'player_typeahead', :with => get_ticker_and_long_name(@player)
          page.execute_script("$('#player_typeahead').trigger('focus');")
          page.execute_script ("$('#player_typeahead').trigger('keydown');")
          selector = "ul.dropdown-menu li a:first-of-type"
          page.should have_selector(selector)
          page.execute_script("$(\"#{selector}\").mouseenter().click()")
          page.should have_field('injury_source', :with => uri.to_s, :disabled => true)
          page.should have_field('player_typeahead', :with => get_ticker_and_long_name(@player))
          fill_in 'player_body_part', :with => 'Calf'
          click_button 'Add'
        end
      end
      sleep 1
    }.to change(Injury, :count).by(1)
  end
end
