class Music < ActiveRecord::Base
  validates :song_title, presence: true
  validates :artist, presence: true
  validates :author, presence: true

end