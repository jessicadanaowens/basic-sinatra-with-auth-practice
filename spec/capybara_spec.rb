require "spec_helper"

  feature "Homepage" do
    scenario "user can see a register button and it takes them to register page" do
      visit "/"

      click_on 'Register'
      expect(page).to have_content("Username")
      expect(page).to have_content("Password")
    end
  end

  feature "Homepage" do
    scenario "user can sign in" do
      visit "/signed_out"

      click_on 'Sign In'
      expect(page).to have_content("Sign Out")
    end

  end

  feature "registration form" do
    scenario "user can fill out form and create an account" do
      visit "/registrations/new"

      click_on 'Register'
      expect(page).to have_content("Thank you for registering")
    end
  end

  feature "signed in page" do
    scenario "user can click logout and be logged out" do
      visit "/signed_in"

      click_on 'Sign Out'
      expect(page).to have_content("Sign In")
    end

  end







