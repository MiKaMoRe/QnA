FactoryBot.define do
  factory :question do
    title { "MyQuestion" }
    body { "Questions body" }

    trait :invalid do
      title { nil }
    end
  end
end
