# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a community
  As an autheticated user
  I'd like to be able ask the question
" do
  given(:user) { create(:user) }

  describe 'autheticated user' do
    background do
      sign_in(user)

      visit root_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test test test'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'test test test'
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test test test'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'multiple sessions' do
    scenario 'question appears on another users page', :js do
      Capybara.using_session('user') do
        sign_in(user)

        visit new_question_path
      end

      Capybara.using_session('guest') do
        visit root_path

        expect(page).not_to have_content 'Test question'
      end

      Capybara.using_session('user') do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test test'
        
        click_on 'Ask'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test test'
      end

      Capybara.using_session('guest') do
        visit root_path

        expect(page).to have_content 'Test question'
      end
    end
  end

  scenario 'unautheticated user tries to ask a question' do
    visit root_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
