require 'dummy_spec_helper'

module DeviseSessionHelpers
  def login_with email, password
    fill_in       "Email",    :with => email
    fill_in       "Password", :with => password
    click_button  "Sign in"
  end

  def login_user
    visit new_user_session_path
    login_with 'stanislaw@gmail.com', "666666"
  end
end

feature "Messages", %q{
  In order to have...
  As an user
  I want to do something with messages} do

  background do
    Capybara.reset_sessions!
  end

  include DeviseSessionHelpers
  
  scenario "Show messages index", :js => true do
    login_user
    visit '/carrier'
  end

  scenario "Show concerto index to musician", :js => true do
    pending
    login_musician
    # save_and_open_page

  end

  scenario "Show concerto to musician" do
    pending

    login_musician

    visit '/concertos/one' # using friendly id :)
    page.should have_content('one')
    visit '/concertos/two'
    page.should have_content('two')
  end
  
  scenario "Show concerto admin index to composer", :js => true do
    pending
    login_composer

    visit '/concertos/admin'
    # save_and_open_page

    #puts page.body.inspect
    page.should have_content('one')
    page.should have_content('two')
  end
end

