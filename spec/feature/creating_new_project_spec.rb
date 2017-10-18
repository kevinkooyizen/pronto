require 'rails_helper'
feature "Signing in" do
  background do
    User.create(full_name: 'Bob', email: 'bob@example.com', password: '123456')
  end

  scenario "Signing in with correct credentials" do
    visit '/sign_in'
    within(".sign-in") do
      fill_in 'Email', with: 'bob@example.com'
      fill_in 'Password', with: '123456'
    end
    click_button 'Sign In'
    expect(page).to have_content 'This is your profile'
  end

  scenario "Signing in with wrong credentials" do
    visit '/sign_in'
    within(".sign-in") do
      fill_in 'Email', with: 'bob@example.com'
      fill_in 'Password', with: '123457'
    end
    click_button 'Sign In'
    expect(page).to have_content 'Sign In'
  end

  scenario "Signing in with empty credentials" do
    visit '/sign_in'
    within(".sign-in") do
      fill_in 'Email', with: 'bob@example.com'
    end
    click_button 'Sign In'
    expect(page).to have_content 'Sign In'
  end
end