# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can delete answers links', "
  As an answer's author
  I'd like to be able to delete links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, author: user, question: question) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Authenticated user remove answers link', :js do
    sign_in(user)
    visit question_path(question)

    within '.answer' do
      expect(page).to have_link link.name, href: link.url
    end

    click_on 'Delete link'

    within '.answer' do
      expect(page).not_to have_link link.name, href: link.url
    end
  end

  scenario 'Unauthenticated user remove answers link' do
    visit question_path(question)

    within '.answer' do
      expect(page).not_to have_link 'Delete link'
    end
  end

  scenario 'Not a author remove answers link' do
    sign_in(create(:user))
    visit question_path(question)

    within '.answer' do
      expect(page).not_to have_link 'Delete link'
    end
  end
end
