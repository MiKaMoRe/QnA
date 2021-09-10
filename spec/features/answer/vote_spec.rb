# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for question', "
  In order to identify a best question
  As an autheticated user
  I'd like to be vote for question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    create(:answer, question: question)
    visit question_path(question)
  end

  scenario 'User voted for a liked question', :js do
    expect(page).not_to have_content 'Cancel my vote'

    click_on 'Like this'

    expect(page).to have_content 'Cancel my vote'
  end

  scenario 'User voted for a disliked question', :js do
    expect(page).not_to have_content 'Cancel my vote'

    click_on 'Dislike this'

    expect(page).to have_content 'Cancel my vote'
  end

  scenario 'User canceled vote', :js do
    click_on 'Like this'
    click_on 'Cancel my vote'

    expect(page).to have_content 'Like this'
    expect(page).to have_content 'Dislike this'
  end
end
