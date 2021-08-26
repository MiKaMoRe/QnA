class Question < ApplicationRecord
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def best_answer
    answers.find_by_best(true)
  end
end
