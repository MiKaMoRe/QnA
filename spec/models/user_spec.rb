require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:created_answers).dependent(:destroy) }
  it { should have_many(:created_questions).dependent(:destroy) }

  it 'author of resource' do
    author = User.create(email: 'user@test.ru', password: '12345678', password_confirmation: '12345678')
    resource = Question.create(title: '111', body: '111', author: author)

    not_author = User.create(email: 'user1@test.ru', password: '12345678', password_confirmation: '12345678')

    expect(author.author_of?(resource)).to be(true)
    expect(not_author.author_of?(resource)).to be(false)
  end
end
