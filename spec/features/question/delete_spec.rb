# frozen_string_literal: true

require 'rails_helper'

feature 'User can remove the question', "
  In order to cancel question
  As an autheticated user
  I'd like to be able remove the question
" do
  given(:user) { create(:user) }

  background do
    create(:question, author: user)
    visit root_path
  end

  scenario 'author tries to delete question' do
    sign_in(user)

    expect(page).to have_content 'MyQuestion'
    expect(page).to have_content 'Questions body'

    click_on 'Delete'

    expect(page).to_not have_content 'MyQuestion'
    expect(page).to_not have_content 'Questions body'
    expect(page).to have_content 'Question successfully deleted'
  end

  scenario 'Not a author tries to delete question' do
    sign_in(create(:user))
    visit root_path
    click_on 'Delete'

    expect(page).to have_content 'You are not a author!'
  end

  scenario 'Unauthenticated user tries to delete question' do
    click_on 'Delete'

    expect(page).to have_content 'Log in'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
