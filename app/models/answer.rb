class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'

  has_many_attached :files

  validates :title, :body, presence: true

  def choose_as_best
    transaction do
      best_answer = question.best_answer
      best_answer.update!(best: false) if best_answer
      update!(best: true)
    end
  end
end
