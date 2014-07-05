require "spec_helper"

  feature "Homepage" do
    scenario "user can see a register button and it takes them to register page" do
      visit "/"

      click_on 'Register'
      expect(page).to have_content("Username:")
      expect(page).to have_content("Password:")
    end
  end

  feature "Hompage" do
    scenario "user sees flash message when sending a post request to the homepage" do
      visit "/registration_form"

      click_on 'Register'
      expect(page).to have_content("Thank you")
    end
  end

feature "Hompage" do
  scenario "User can Login and see flash message" do
    visit "/"

    click_on 'Login'
    expect(page).to have_content("Welcome")
  end
end

feature "Click Log out" do
  scenario "User clicks logout and is redirected to homepage" do
    visit "/logout"

    click_on 'Logout'
    expect(page).to have_content("Username:")
  end
end




