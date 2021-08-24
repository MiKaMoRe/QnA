class Question < ApplicationRecord
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'
  belongs_to :best_answer, foreign_key: 'best_answer_id', class_name: 'Answer', optional: true

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
