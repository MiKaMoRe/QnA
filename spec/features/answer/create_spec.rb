# frozen_string_literal: true

require 'rails_helper'

feature 'User can answer the question', "
  In order to help some other user
  As an autheticated user
  I'd like to be able answer the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Autheticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Title', with: 'Test answer'
      fill_in 'Body', with: 'test test test'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully posted.'
      expect(page).to have_content 'Test answer'
      expect(page).to have_content 'test test test'
    end

    scenario 'answer the question with errors' do
      click_on 'Answer'
      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'unautheticated user tries to answer the question', js: true do
    visit question_path(question)
    fill_in 'Title', with: 'Test answer'
    fill_in 'Body', with: 'test test test'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
