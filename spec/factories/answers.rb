# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    title { 'MyAnswer' }
    body { 'Aswers body' }
    association :author, factory: :user
    question
    
    trait :with_files do
      files { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"), Rack::Test::UploadedFile.new("#{Rails.root}/spec/spec_helper.rb")] }
    end

    trait :invalid do
      title { nil }
    end
  end
end
