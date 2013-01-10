# == Schema Information
#
# Table name: credits
#
#  id         :integer          not null, primary key
#  image_id   :integer
#  artist_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Credit < ActiveRecord::Base
	belongs_to :artist
	belongs_to :image
	attr_accessible :image_id, :artist_id

	validates :artist_id, numericality: true, presence: true
	validates :image_id, numericality: true, presence: true
end
