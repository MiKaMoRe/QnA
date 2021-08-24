# frozen_string_literal: true

require 'rails_helper'

feature 'User can open the question', "
  In order to find answer
  As an unautheticated user
  I'd like to be able open the question
" do
  describe 'when authenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question, author: user) }
    given!(:answer) { create(:answer, question: question) }

    background do
      sign_in(user)
    end

    scenario 'choose the best answer of his question', js: true do
      visit question_path(question)
      click_on 'Choose as best'

      expect(page).not_to have_content 'Choose as best'
      expect(page).to have_content 'Best answer'
    end

    scenario 'choose other answer of his question', js: true do
      create(:answer, question: question, body: 'second answer')
      visit question_path(question)

      within '.answer:nth-child(2)' do
        click_on 'Choose as best'
      end
      
      within '.best-answer' do
        expect(page).to have_content 'second answer'
      end
    end

    scenario 'choose a best answer of another question' do
      visit question_path(create(:question))

      expect(page).not_to have_content 'Choose as best'
    end
  end

  describe 'when unauthenticated user' do
    given!(:answer) { create(:answer) }

    scenario 'user open questions list' do
      visit root_path
      click_on 'Open answers'
  
      expect(page).to have_content answer.title
      expect(page).to have_content answer.body
      expect(page).to have_content answer.question.title
      expect(page).to have_content answer.question.body
    end

    scenario "choose a best answer" do
      visit question_path(create(:question))

      expect(page).not_to have_content 'Choose as best'
    end
  end
end
