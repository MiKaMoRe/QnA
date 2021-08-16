require 'rails_helper'

feature 'User can remove the answer', %q{
  In order to cancel answer
  As an autheticated user
  I'd like to be able remove the answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  background do
    create(:answer, question: question, author: user)
    visit question_path(question)
  end

  scenario 'Author tries to delete answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content 'MyAnswer'
    expect(page).to have_content 'Aswers body'

    click_on 'Delete'

    expect(page).to_not have_content 'MyAnswer'
    expect(page).to_not have_content 'Aswers body'
    expect(page).to have_content 'Answer successfully deleted'
  end

  scenario 'Not a author tries to delete answer' do
    sign_in(create(:user))
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'You are not a author!'
  end

  scenario 'Unauthenticated user tries to delete answer' do
    click_on 'Delete'

    expect(page).to have_content 'Log in'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
