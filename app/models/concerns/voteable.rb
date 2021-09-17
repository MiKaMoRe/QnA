module Voteable
  extend ActiveSupport::Concern
  
  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def vote_from(user)
    votes.where(author: user).first
  end

  def liked_from?(user)
    vote_from(user).liked if vote_from(user)
  end

  def total_votes
    votes.where(liked: true).count - votes.where(liked: false).count
  end
end
