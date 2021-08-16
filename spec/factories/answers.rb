FactoryBot.define do
  factory :answer do
    title { "MyAnswer" }
    body { "Aswers body" }

    trait :invalid do
      title { nil }
    end
  end
end
