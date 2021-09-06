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

  scenario 'author tries to delete question', :js do
    sign_in(user)

    expect(page).to have_content 'MyQuestion'
    expect(page).to have_content 'Questions body'

    click_on 'Delete'

    expect(page).not_to have_content 'MyQuestion'
    expect(page).not_to have_content 'Questions body'
    expect(page).to have_content 'Question successfully deleted'
  end

  scenario 'not a author tries to delete question' do
    sign_in(create(:user))
    visit root_path

    expect(page).not_to have_content 'Delete'
  end

  scenario 'unauthenticated user tries to delete question' do
    expect(page).not_to have_content 'Delete'
  end
end
