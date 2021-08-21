# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyQuestion' }
    body { 'Questions body' }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end
  end
end
