# frozen_string_literal: true

require 'rails_helper'

feature 'User can add reward to question', "
  In order to give reward to user who create best answer
  As an creator of question
  I'd like to be able add reward to question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:reward) { create(:reward, question: question) }
  given!(:answer) { create(:answer, author: user, question: question) }

  scenario 'author of question choose your answer', :js do
    sign_in(user)
    visit rewards_path

    expect(page).not_to have_content reward.description

    visit question_path(question)
    click_on 'Choose as best'
    visit rewards_path
    
    expect(page).to have_content reward.description
  end
end
