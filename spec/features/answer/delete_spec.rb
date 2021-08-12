require 'rails_helper'

feature 'User can remove the answer', %q{
  In order to cancel answer
  As an autheticated user
  I'd like to be able remove the answer
} do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  background do
    create(:answer, question: question, author: user)
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Author tries to delete answer' do
    click_on 'Delete'
    expect(page).to have_content 'Answer successfully deleted'
  end

  scenario 'Not a author tries to delete answer' do
    click_on 'Log out'
    sign_in(create(:user))
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'You are not a author!'
  end
end
