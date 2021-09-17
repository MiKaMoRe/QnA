class User < ApplicationRecord
  include Voteable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :created_answers, foreign_key: 'author_id', class_name: 'Answer', dependent: :destroy
  has_many :created_questions, foreign_key: 'author_id', class_name: 'Question', dependent: :destroy
  has_many :rewards, dependent: :destroy

  def author_of?(resource)
    resource.author_id == id
  end
end
