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

require 'spec_helper'

describe Image do
	before do
		@image = Image.new(image_link: "http://host.com/link/to/Image.jpG",
						facebook_link: "http://facebook.com/link/to/Image.jpG",
						   gplus_link: "http://plus.google.com/Image.jpG")
	end

	bad_link_tests = [
		"ftp://hosting.com/image",
		"ftp://hosting.com/image.jpg",
		"http://hosting.com/image.jpg",
		"hosting/image.jpg",
		"hosting",
		"http://hosting/image.jpg",
		"https://hosting.com",
		"hosting.com",
		"hosting.com/image.jpg"
	]

	good_link_tests = [	
		"http://hosting.com/image.jpg",
		"https://hosting.com/image.jpg"
	]

	subject { @image }

	it { should respond_to(:image_link) }
	it { should respond_to(:facebook_link) }
	it { should respond_to(:gplus_link) }
	it { should respond_to(:is_commercial) }
	it { should respond_to(:is_filtered) }
	it { should respond_to(:is_front_page) }
	it { should respond_to(:is_published) }

	describe ":image_link" do
		describe "must not be null" do
			before { @image.image_link = nil }
			it { should_not be_valid }
		end

		describe "must include http and point directly to image file" do
			bad_link_tests.each do |bad_link_test|
				before { @image.image_link = bad_link_test }
				it { should_not be_valid }
			end
		end

		describe "should accept http and https" do
			good_link_tests.each do |good_link_test|
				before { @image.image_link = good_link_test }
				it { should be_valid }
			end
		end

		describe "must not be a duplicate" do
			before do
				duplicate_link = @image.dup
				duplicate_link.facebook_link = "http://facebook.com/other.jpg"
				duplicate_link.gplus_link = "http://plus.google.com/other.jpg"
				duplicate_link.save
			end

			it { should_not be_valid }
		end
	end

	describe ":facebook_link" do
		describe "must allow null value" do
			before { @image.facebook_link = nil }
			it { should be_valid }
		end

		describe "must point to facebook.com domain" do
			before { @image.facebook_link = "http://random.com/image.jpg" }
			it { should_not be_valid }
		end

		describe "must include http and point directly to image file" do
			bad_link_tests.each do |bad_link_test|
				before do 
					@image.facebook_link = bad_link_test.gsub("hosting", 
															"facebook") 
				end

				it { should_not be_valid }
			end
		end

		describe "should accept http and https" do
			good_link_tests.each do |good_link_test|
				before do 
					@image.facebook_link = good_link_test.gsub("hosting",
															"facebook")
				end

				it { should be_valid }
			end
		end

		describe "must not be duplicate" do
			before do
				facebook_duplicate = @image.dup
				facebook_duplicate.image_link = "http://place.com/else.jpg"
				facebook_duplicate.gplus_link = "http://google.com/else.jpg"
				facebook_duplicate.save
			end

			it { should_not be_valid }
		end
	end

	describe ":gplus_link" do
		describe "must allow null value" do
			before { @image.gplus_link = nil }
			it { should be_valid }
		end

		describe "must point to google domain" do
			before { @image.gplus_link = "http://random.com/image.jpg" }
			it { should_not be_valid }
		end

		describe "must include http and point directly to image file" do
			bad_link_tests.each do |bad_link_test|
				before do 
					@image.gplus_link = bad_link_test.gsub("hosting", 
															"google") 
				end

				it { should_not be_valid }
			end
		end

		describe "should accept http and https" do
			good_link_tests.each do |good_link_test|
				before do 
					@image.gplus_link = good_link_test.gsub("hosting",
															"google")
				end

				it { should be_valid }
			end
		end

		describe "must not be duplicate" do
			before do
				gplus_duplicate = @image.dup
				gplus_duplicate.image_link = "http://place.com/else.jpg"
				gplus_duplicate.facebook_link = "http://facebook.com/else.jpg"
				gplus_duplicate.save
			end

			it { should_not be_valid }
		end
	end

	describe "default attributes when not specified" do
		before { @image.save }

		it ":is_commercial must be saved as false" do
			@image.reload.is_commercial.should == false
		end

		it ":is_filtered must be saved as true" do
			@image.reload.is_filtered.should == true
		end

		it ":is_front_page must be saved as false" do
			@image.reload.is_front_page.should == false
		end

		it ":is_published must be saved as false" do
			@image.reload.is_published.should == false
		end

		it ":view_count must start from 0" do
			@image.reload.view_count.should == 0
		end
	end

	describe "overridden default attributes" do
		before do
			@image.is_commercial = true
			@image.is_filtered = false
			@image.is_front_page = true
			@image.is_published = true
			@image.save
		end

		it ":is_commercial must accept overridden value" do
			@image.reload.is_commercial.should == @image.is_commercial
		end

		it ":is_filtered must accept overridden value" do
			@image.reload.is_filtered.should == @image.is_filtered
		end

		it ":is_front_page must accept overridden value" do
			@image.reload.is_front_page.should == @image.is_front_page
		end

		it ":is_published must accept overridden value" do
			@image.reload.is_published.should == @image.is_published
		end
	end

	describe "case-sensitivity" do
		before { @image.save }

		it "on :image_link must be preserved" do
			@image.reload.image_link.should == @image.image_link
		end

		it "on :facebook_link must be preserved" do
			@image.reload.facebook_link.should == @image.facebook_link
		end

		it "on :gplus_link must be preserved" do
			@image.reload.gplus_link.should == @image.gplus_link
		end
	end

	describe ":image_count should only take 0 or positive integer" do
		image_count_tests = ["a", -1, nil, ""]
		image_count_tests.each do |image_count_test|
			before do
				@image.view_count = image_count_test

				it { should_not be_valid }
			end
		end
	end

	describe ":view_count" do
		let(:view_count_test) { 1234567 }
		before do
			@image.view_count = view_count_test
			@image.save
		end

		it "should take zero and any positive integer" do
			@image.reload.view_count.should == view_count_test
		end
	end
end
