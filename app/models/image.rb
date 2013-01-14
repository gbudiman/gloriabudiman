# == Schema Information
#
# Table name: images
#
#  id            :integer          not null, primary key
#  image_link    :string(255)
#  facebook_link :string(255)
#  gplus_link    :string(255)
#  is_commercial :boolean
#  is_filtered   :boolean
#  is_front_page :boolean
#  is_published  :boolean
#  view_count    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Image < ActiveRecord::Base
	has_many :artist, through: :credit
	has_many :credit, dependent: :destroy
	attr_accessible :view_count, :image_link, :facebook_link, :gplus_link,
				:is_commercial, :is_filtered, :is_front_page, :is_published

	before_save do 
		self.is_commercial ||= false
		self.is_filtered ||= true
		self.is_front_page ||= false
		self.is_published ||= false
		self.view_count ||= 0 
	end

	VALID_SIMPLE_URI = /http[s]?\:\/\/([\w\-\.\/]+\.[\w]+){2,}/i
	VALID_FACEBOOK_URI = 
		/http[s]?\:\/\/[\w\-\.\/]*facebook\.com[\w\-\.\/]+\.[\w]+/i
	VALID_GPLUS_URI = 
		/http[s]?\:\/\/[\w\-\.\/]*google[\w\-\.\/]+\.[\w]+/i

	validates :image_link, presence: true,
						format:  		{ with: VALID_SIMPLE_URI },
						uniqueness:    	{ case_sensitive: true }
	validates :facebook_link, allow_nil: true,
						format: 		{ with: VALID_FACEBOOK_URI},
						uniqueness: 	{ case_sensitive: true }
	validates :gplus_link, allow_nil: true,
						format: 		{ with: VALID_GPLUS_URI },
						uniqueness: 	{ case_sensitive: true }
	validates :view_count, allow_nil: true,
						numericality: 	{ greater_than_or_equal_to: 0 }
end
