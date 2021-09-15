# frozen_string_literal: true

require 'rails_helper'

feature 'User can comment the resource', "
  In order to give feedback
  As an autheticated user
  I'd like to be able comment a resources
" do
  background { create(:question) }

  describe 'Autheticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)

      visit root_path
    end

    scenario 'add comment to the question' do
      expect(page).not_to have_content 'Test comment'

      within '.new-comment' do
        fill_in 'Comment', with: 'Test comment'
        click_on 'Comment'
      end
      
      expect(page).to have_content 'Your comment successfully posted.'
      expect(page).to have_content 'Test comment'
    end

    scenario 'answer the question with errors' do
      click_on 'Comment'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'unautheticated user tries to comment the question', :js do
    visit root_path
    click_on 'Comment'

    expect(page).not_to have_content 'Test comment'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
