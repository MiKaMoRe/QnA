# Preview all emails at http://localhost:3000/rails/mailers/question_subscription
class QuestionSubscriptionPreview < ActionMailer::Preview
  def digest
    DailyDigestMailer.digest
  end
end
