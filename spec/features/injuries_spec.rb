require 'spec_helper'

feature 'Injury management' do 
  background do
    login_user
    @player = create(:player)
    @ticker_and_long_name = "#{@player.short_name} #{@player.long_name}"
  end

  scenario "add confirmed injury", js: true do
    expect {
      visit injuries_path
      within '.injuries-form-container' do
        find("option[value='confirmed']").click
        fill_in 'player_typeahead', :with => @ticker_and_long_name
        page.execute_script("$('#player_typeahead').trigger('focus');")
        page.execute_script ("$('#player_typeahead').trigger('keydown');")
        selector = "ul.dropdown-menu li a:first-of-type"
        page.should have_selector(selector)
        page.execute_script("$(\"#{selector}\").mouseenter().click()")
        page.should have_field('player_typeahead', :with => @ticker_and_long_name)
        click_button 'Add'
      end
      sleep 1
    }.to change(Injury, :count).by(1)
  end
end
