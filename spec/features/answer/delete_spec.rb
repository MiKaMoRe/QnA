# frozen_string_literal: true

require 'rails_helper'

feature 'User can remove the answer', "
  In order to cancel answer
  As an autheticated user
  I'd like to be able remove the answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  background do
    create(:answer, question: question, author: user)
    visit question_path(question)
  end

  scenario 'author tries to delete answer', :js do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content 'MyAnswer'
    expect(page).to have_content 'Aswers body'

    click_on 'Delete'

    expect(page).not_to have_content 'MyAnswer'
    expect(page).not_to have_content 'Aswers body'
    expect(page).to have_content 'Answer successfully deleted'
  end

  scenario 'not a author tries to delete answer' do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).not_to have_content 'Delete'
  end

  scenario 'unauthenticated user tries to delete answer' do
    expect(page).not_to have_content 'Delete'
  end
end
