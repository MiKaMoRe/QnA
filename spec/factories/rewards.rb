FactoryBot.define do
  factory :reward do
    description { "MyReward" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/files/reward.png") }
    question
  end
end
