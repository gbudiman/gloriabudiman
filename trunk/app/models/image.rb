# == Schema Information
#
# Table name: images
#
#  id            :integer          not null, primary key
#  credit_id     :integer
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
	has_many :artist, :through => :credit
	attr_accessible :credit_id, :image_link, :facebook_link, :gplus_link,
				:is_commercial, :is_filtered, :is_front_page, :is_published,
				:view_count
end
