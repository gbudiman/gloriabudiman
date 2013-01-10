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

require 'spec_helper'

describe Credit do
	before do
		@credit = Credit.new(image_id: 1, artist_id: 1)
	end

	subject { @credit }

	it { should respond_to(:image_id) }
	it { should respond_to(:artist_id) }

	describe ":artist_id" do
		describe "should not be null or empty" do
			artist_id_tests = [nil, "", " "]
			artist_id_tests.each do |artist_id_test|
				before { @credit.artist_id = artist_id_test }
				it { should_not be_valid }
			end
		end

		describe "should be valid" do
			it { should be_valid }
		end
	end

	describe ":image_id" do
		describe "should not be null or empty" do
			image_id_tests = [nil, "", " "]
			image_id_tests.each do |image_id_test|
				before { @credit.image_id = image_id_test }
				it { should_not be_valid }
			end
		end

		describe "should be valid" do
			it { should be_valid }
		end
	end
end
