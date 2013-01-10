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

require 'spec_helper'

describe Image do
	before do
		@image = Image.new(credit_id: 0,
						  image_link: "http://host.com/link/to/image",
					   facebook_link: "http://facebook.com/link/to/image",
						  gplus_link: "http://plus.google.com/link/to/image",
						  view_count: 0)
	end
end
