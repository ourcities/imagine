class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :image, :last_name, :uid, :token
  validates :email, :first_name, :presence => true
  validates :email, :uniqueness => true
  has_many :votes
  has_many :contributions

  def name
    "#{first_name} #{last_name}"
  end

  def can_vote_for? idea
    self.votes.where(idea_id: idea.id).empty?
  end

  def pending_contributions
    Contribution.joins(:idea).where("accepted_at IS NULL AND rejected_at IS NULL AND ideas.user_id = ?", self.id)
  end

  def voted_on? idea
    self.votes.where(idea_id: idea.id).any?
  end
  
  def contributed_to? idea
    self.contributions.where(idea_id: idea.id).any?
  end
end
