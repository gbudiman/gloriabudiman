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

	validates :artist_id, presence: true
	validates :image_id, presence: true
end
