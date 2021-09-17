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

    scenario 'answer a question with attached file' do
      fill_in 'Title', with: 'Test answer'
      fill_in 'Body', with: 'test test test'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'answer the question with errors' do
      click_on 'Answer'
      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'multiple sessions' do
    given(:question) { create(:question) }

    scenario 'answer appears on another users page', :js do
      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        expect(page).not_to have_content 'Test answer'
      end

      Capybara.using_session('user') do
        fill_in 'Title', with: 'Test answer'
        fill_in 'Body', with: 'test test'
        
        click_on 'Answer'

        expect(page).to have_content 'Test answer'
        expect(page).to have_content 'test test'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test answer'
      end
    end
  end

  scenario 'unautheticated user tries to answer the question', :js do
    visit question_path(question)
    fill_in 'Title', with: 'Test answer'
    fill_in 'Body', with: 'test test test'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
