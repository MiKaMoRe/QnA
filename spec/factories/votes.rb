FactoryBot.define do
  factory :vote do
    author { create(:user) }
    voteable { create(:question) }
    liked { true }
  end
end
