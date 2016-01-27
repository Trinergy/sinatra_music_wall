class Upvote < ActiveRecord::Base
  validates :music, presence: true, uniqueness: {scope: :user}
  validates :user, presence: true
  
  belongs_to :music
  belongs_to :user

end