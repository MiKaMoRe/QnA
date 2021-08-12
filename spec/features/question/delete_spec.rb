require 'rails_helper'

feature 'User can remove the question', %q{
  In order to cancel question
  As an autheticated user
  I'd like to be able remove the question
} do
  given(:user) { create(:user) }

  background do
    create(:question, author: user)
    sign_in(user)
    visit root_path
  end

  scenario 'Author tries to delete question' do
    click_on 'Delete'
    expect(page).to have_content 'Question successfully deleted'
  end

  scenario 'Not a author tries to delete question' do
    click_on 'Log out'
    sign_in(create(:user))
    visit root_path
    click_on 'Delete'

    expect(page).to have_content 'You are not a author!'
  end
end
