require 'rails_helper'
feature "Signing in" do
  background do
    User.create(full_name: 'Bob', email: 'bob@example.com', password: '123456')
  end

  scenario "Signing in and creating a project" do
    visit '/sign_in'
    within(".sign-in") do
      fill_in 'Email', with: 'bob@example.com'
      fill_in 'Password', with: '123456'
    end
    click_button 'Sign In'
    expect(page).to have_content 'This is your profile'
    visit '/projects/new'
    within("#new_project") do
      fill_in 'Name', with: "Test Project"
    end
    click_button "Create Project"
    expect(page).to have_content 'This is Test project Project'
  end

  scenario "Signing in and creating a project without a project name" do
    visit '/sign_in'
    within(".sign-in") do
      fill_in 'Email', with: 'bob@example.com'
      fill_in 'Password', with: '123456'
    end
    click_button 'Sign In'
    expect(page).to have_content 'This is your profile'
    visit '/projects/new'
    click_button "Create Project"
    expect(page).to have_content "Name can't be blank"
  end

  scenario "Signing in with incorrect credentials", js: true do
    visit '/sign_in'
    within(".sign-in") do
      fill_in 'Email', with: 'bob@example.com'
      fill_in 'Password', with: '123457'
    end
    click_button 'Sign In'
    expect(page).to have_content 'Invalid email or password'
  end
end