class Answer < ApplicationRecord
  include Voteable

  belongs_to :question
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'

  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, dependent: :destroy, as: :commentable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true

  def choose_as_best
    transaction do
      best_answer = question.best_answer
      reward = question.reward

      reward.give_to author if reward
      best_answer.update!(best: false) if best_answer
      
      update!(best: true)
    end
  end
end
