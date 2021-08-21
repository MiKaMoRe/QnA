# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    title { 'MyAnswer' }
    body { 'Aswers body' }
    association :author, factory: :user
    question

    trait :invalid do
      title { nil }
    end
  end
end
