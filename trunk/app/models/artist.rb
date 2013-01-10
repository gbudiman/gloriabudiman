# == Schema Information
#
# Table name: artists
#
#  id          :integer          not null, primary key
#  artist_name :string(255)
#  page_link   :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Artist < ActiveRecord::Base
	belongs_to :user
	has_one :user
	attr_accessible :artist_name, :page_link, :user_id
	before_save { self.page_link.downcase! }

	VALID_STRING_REGEX = /^[\w\-\s]+$/

	validates :artist_name, presence: true, 
					format:  		{ with: VALID_STRING_REGEX },
					length: 		{ minimum: 4, maximum: 32 },
					uniqueness: 	{ case_sensitive: true }
	validates :page_link, presence: true,
					format: 		{ with: VALID_STRING_REGEX },
					length: 		{ minimum: 4, maximum: 32 },
					uniqueness:  	{ case_sensitive: false }
end
