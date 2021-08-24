class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'

  has_one :best_of, foreign_key: 'best_answer_id', class_name: 'Question', dependent: :nullify

  validates :title, :body, presence: true

  def nominate
    self.best_of = question
  end

  def best?
    !best_of.nil?
  end
end
