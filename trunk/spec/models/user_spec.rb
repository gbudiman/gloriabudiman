# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)
#  email           :string(255)
#  level           :integer
#  artist_id       :integer
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe User do
	before do 
		@user = User.new(username: "Sample Name",
						    email: "valid_email@address.com",
							level: 1,
						artist_id: 0,
				  		 password: "secure",
			password_confirmation: "secure")
	end

	subject { @user }

	it { should respond_to(:username) }
	it { should respond_to(:email) }
	it { should respond_to(:level) }
	it { should respond_to(:artist_id) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }

	describe ":username" do
		describe "should not be zero length" do
			before { @user.username = "" }
			it { should_not be_valid }
		end

		describe "should not be empty" do
			before { @user.username = "    " }
			it { should_not be_valid }
		end

		describe "should not be shorter than 4 characters" do
			before { @user.username = "abc" }
			it { should_not be_valid }
		end

		describe "must be unique" do
			before {
				duplicate_user = @user.dup
				duplicate_user.email = "something@different.com"
				duplicate_user.save
			}

			it { should_not be_valid }
		end

		describe "case-sensitivity must not trigger uniqueness check" do
			before do
				duplicate_user = @user.dup
				duplicate_user.username = @user.username.upcase
				duplicate_user.email = "something@different.com"
				duplicate_user.save
			end

			it { should be_valid }
		end

		describe "case-sensitivity" do
			it "must be preserved " do
				@user.save
				@user.reload.username.should == @user.username
			end
		end

		describe "must only contain ws- regex class character" do
			username_tests = ["abcde@fgh", "x& ()abdc", "\\abcde\%"]
			username_tests.each do |username_test|
				before { @user.username = username_test }
				it { should_not be_valid }
			end
		end

		describe "should be valid" do
			it { should be_valid }
		end
	end

	describe ":email" do
		describe "must adhere to valid address format" do
			addresses = %w[user@foo,com
						user_at_foo.org
						example.user@foo.foo@bar_baz.com
						foo@bar+baz.com]
			addresses.each do |invalid_address|
				before { @user.email = invalid_address }
				it { should_not be_valid }
			end
		end

		describe "should be valid" do
			addresses = %w[user@foo.COM
						A_US-ER@f.b.org
						frst.lst@foo.jp
						a+b@baz.cn]
			addresses.each do |valid_address|
				before { @user.email = valid_address }
				it { should be_valid }
			end
		end

		describe "must be unique" do
			before do
				user_with_duplicate_email = @user.dup
				user_with_duplicate_email.email = @user.email.upcase
				user_with_duplicate_email.save
			end

			it { should_not be_valid }
		end

		describe "when being mixed case" do
			let(:mixed_case_email) { "mIxEd_cAsE@eXaMpLe.CoM" }

			it "must be saved as lower case" do
				@user.email = mixed_case_email
				@user.save
				@user.reload.email.should == mixed_case_email.downcase
			end
		end
	end

	describe ":level" do
		describe "must be between 1 and 8" do
			level_tests = [nil, 0, 9, "blabla"]
			level_tests.each do |level_test|
				before { @user.level = level_test }
				it { should_not be_valid }
			end
		end

		describe "should be valid" do
			it { should be_valid }
		end
	end

	describe ":artist_id" do
		describe "must be numeric value" do
			artist_id_tests = [nil, "blabla"]
			artist_id_tests.each do |artist_id_test|
				before { @user.artist_id = artist_id_test }
				it { should_not be_valid }
			end
		end

		describe "should be valid" do
			it { should be_valid }
		end
	end

	describe ":password" do
		describe "should be between 6 to 32 characters-length" do 
			password_tests = [nil, "abcde", "      ", "a" * 33]
			password_tests.each do |password_test|
				before do
					@user.password = password_test
					@user.password_confirmation = password_test
				end
				it { should_not be_valid }
			end
		end

		describe "must match :password_confirmation" do
			password_confirmation_tests = [nil, "      ", "different"]
			password_confirmation_tests.each do |password_confirmation_test|
				before do
					@user.password_confirmation = password_confirmation_test
				end
				it { should_not be_valid }
			end
		end

		describe "authentication" do
			before { @user.save }
			let(:found_user) { User.find_by_email(@user.email) }

			describe "with valid password" do
				it { should == found_user.authenticate(@user.password)}
			end

			describe "with invalid password" do
				let(:user_for_invalid_password) do
					found_user.authenticate("invalid")
				end
				it { should_not == user_for_invalid_password }
				specify { user_for_invalid_password.should be_false }
			end
		end

		describe "should be valid" do
			it { should be_valid }
		end
	end
end
