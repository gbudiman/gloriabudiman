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
		@artist = FactoryGirl.create(:artist)
		@user = FactoryGirl.create(:user)
		@another_user = FactoryGirl.create(:user,
			username: "Another Dude",
			email: "another@dude.com")
	end

	subject { @artist }

	it { should respond_to(:artist_name) }
	it { should respond_to(:page_link) }

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
				@user.save
				@artist.save
				@another_user.save

				@another_artist = FactoryGirl.create(:artist,
					artist_name: @artist.artist_name,
					page_link: "another_artist",
					user_id: @another_user.reload.id)
				expect { @another_artist.save }.
					to raise_error(ActiveRecord::RecordInvalid)

			end
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
				@user.save
				@artist.save
				@another_user.save

				@another_artist = FactoryGirl.create(:artist,
					artist_name: "Another Dude",
					page_link: @artist.page_link,
					user_id: @another_user.reload.id)
				expect { @another_artist.save }.
					to raise_error(ActiveRecord::RecordInvalid)
			end
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

	describe "must not be saved when no associated User exists" do
		before do
			@user.destroy
			expect { @artist.save }.
				to raise_error(ActiveRecord::RecordInvalid)
		end
	end
end
