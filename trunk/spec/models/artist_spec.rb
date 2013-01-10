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

require 'spec_helper'

describe Artist do
	before do
		@artist = Artist.new(artist_name: "Sample Artist",
							   page_link: "sample_artist",
							     user_id: 0)
	end

	subject { @artist }

	it { should respond_to(:artist_name) }
	it { should respond_to(:page_link) }
	it { should respond_to(:user_id) }

	describe ":artist_name" do
		describe "must be between 4 to 32 characters-length" do
			artist_name_tests = [nil,
								"abc",
								"      ",
								"a" * 33]

			artist_name_tests.each do |artist_name_test|
				before { @artist.artist_name = artist_name_test }
				it { should_not be_valid }
			end
		end

		describe "must be unique" do
			before do
				duplicate_artist = @artist.dup
				duplicate_artist.page_link = "somewhere_else"
				duplicate_artist.save
			end

			it { should_not be_valid }
		end

		describe "case-sensitivity must not trigger uniqueness check" do
			before do
				duplicate_artist = @artist.dup
				duplicate_artist.artist_name = @artist.artist_name.upcase
				duplicate_artist.page_link = "somewhere_else"
				duplicate_artist.save
			end

			it { should be_valid }
		end

		describe "case-sensitivity" do
			it "must be preserved" do
				@artist.save
				@artist.reload.artist_name.should == @artist.artist_name
			end
		end

		describe "must only contain ws- regex class character" do
			artist_name_tests = ["abcde@fgh", "x& ()abdc", "\\abcde\%"]
			artist_name_tests.each do |artist_name_test|
				before { @artist.artist_name = artist_name_test }
				it { should_not be_valid }
			end
		end

		describe "should be valid" do
			it { should be_valid }
		end
	end

	describe "page_link" do
		describe "must be between 4 to 32 characters-length" do
			page_link_tests = [nil,
								"abc",
								"      ",
								"a" * 33]

			page_link_tests.each do |page_link_test|
				before { @artist.page_link = page_link_test }
				it { should_not be_valid }
			end
		end

		describe "must be unique" do
			before do
				duplicate_artist = @artist.dup
				duplicate_artist.artist_name = "Someone Else"
				duplicate_artist.save
			end

			it { should_not be_valid }
		end

		describe "when being mixed case" do
			let(:funky_address) { "fUnkY_PaGe_adDreSs" }

			it "must be saved as lower case" do
				@artist.page_link = funky_address
				@artist.save
				@artist.reload.page_link.should == funky_address.downcase
			end
		end

		describe "must only contain ws- regex class character" do
			page_link_tests = ["abcde@fgh", "x& ()abdc", "\\abcde\%"]
			page_link_tests.each do |page_link_test|
				before { @artist.page_link = page_link_test }
				it { should_not be_valid }
			end
		end

		describe "should be valid" do
			it { should be_valid }
		end
	end
end
