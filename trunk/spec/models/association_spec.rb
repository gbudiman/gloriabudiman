require 'spec_helper'

describe "User <-> Artist relation" do
	before do
		@user = FactoryGirl.create(:user)
		@artist = FactoryGirl.create(:artist)
		@another_artist = FactoryGirl.create(:artist,
			artist_name: "Another Artist",
			page_link: "another_artist",
			user_id: 1)

		@user.save
		@artist.save
	end

	it "must be able to access User by specifying Artist.artist_id" do
		@artist.reload.user_id = @user.reload.id
		@artist.save
		User.find(@artist.reload.user_id).should == @user.reload
	end

	describe "when cascading deletion" do
		before { @user.destroy }

		it "must remove User record from database" do
			expect { @user.reload }.
				to raise_error(ActiveRecord::RecordNotFound)
		end

		it "must not cascade deletion to Artist" do
			expect { @artist.reload }.
				to_not raise_error(ActiveRecord::RecordNotFound)
		end

		it "must nullify Artist foreign key :user_id" do
			@artist.reload.user_id.should == nil
		end
	end

	describe "must not have 2 Artist pointing to 1 User" do
		before do 
			expect { @another_artist.save }.
				to raise_error(ActiveRecord::RecordInvalid)
		end
	end
end

describe "Artist <-> Credit <-> Image relation" do
	before do
		@credit = Credit.new()
	end

	it "should validate Image existence" do
		@artist = FactoryGirl.create(:artist)
		@credit.should_not be_valid
	end

	it "should validate Artist existence" do
		@image = Image.new(image_link: "http://host.com/link.jpg")
		@credit.should_not be_valid
	end

	describe "when dependency is satisfied" do
		before do
			@image = Image.new(image_link: "http://host.com/link.jpg")
			@artist = FactoryGirl.create(:artist)
			@image.save
			@artist.save

			@credit.artist_id = @artist.reload.id
			@credit.image_id = @image.reload.id
		end

		describe "should be successfully saved" do
			before { @credit.save }

			it "and retrievable from database" do
				@credit.reload.should_not == nil
			end

			it "and should be able to reference Artist" do
				Artist.find_by_id(@credit.reload.artist_id).
					should == @artist.reload
			end

			it "and should be able to reference Image" do
				Image.find_by_id(@credit.reload.image_id).
					should == @image.reload
			end

			it "and should be able to reference Image -> Credit -> Artist" do
				Artist.find_by_id(Credit.find_by_image_id(@image.reload.id)).
					should == @artist.reload
			end

			it "and should be able to reference Artist -> Credit -> Image" do
				Image.find_by_id(Credit.find_by_artist_id(@artist.reload.id)).
					should == @image.reload
			end
		end
	end

	describe "on deletion of" do
		before do
			@image = Image.new(image_link: "http://host.com/link.jpg")
			@artist = FactoryGirl.create(:artist)
			@image.save
			@artist.save

			@credit.artist_id = @artist.reload.id
			@credit.image_id = @image.reload.id
			@credit.save
		end

		describe "Image" do
			before { @image.destroy }

			it "should successfully remove record from database" do
				expect { @image.reload }.
					to raise_error(ActiveRecord::RecordNotFound)
			end

			it "should cascade deletion to Credit" do
				expect { @credit.reload }.
					to raise_error(ActiveRecord::RecordNotFound)
			end

			it "must not cascade deletion to Artist" do
				expect { @artist.reload }.
					to_not raise_error(ActiveRecord::RecordNotFound)
			end
		end

		describe "Artist" do
			before { @artist.destroy }

			it "should successfully remove record from database" do
				expect { @artist.reload }.
					to raise_error(ActiveRecord::RecordNotFound)
			end

			it "should cascade deletion to Credit" do
				expect { @credit.reload }.
					to raise_error(ActiveRecord::RecordNotFound)
			end

			it "must not cascade deletion to Image" do
				expect { @image.reload }.
					to_not raise_error(ActiveRecord::RecordNotFound)
			end
		end
	end

	describe "when having 2 Credit containing identical Artist reference" do
		before do
			@credit_duplicate = Credit.new()
			@artist = FactoryGirl.create(:artist)
			@image_1 = FactoryGirl.create(:image)
			@image_2 = FactoryGirl.create(:image,
				image_link: "http://other.hosting.com/link_1.jpg")

			@artist.save
			@image_1.save
			@image_2.save

			@credit.artist_id = @artist.reload.id
			@credit.image_id = @image_1.reload.id

			@credit_duplicate.artist_id = @artist.reload.id
			@credit_duplicate.image_id = @image_1.reload.id
		end

		it ", they must not point to one Image record" do
			expect { @credit.save }.
				to_not raise_error(ActiveRecord::RecordInvalid)

			expect { @credit_duplicate.save }.
				to raise_error(ActiveRecord::RecordNotUnique)
		end

		describe ", referencing multiple Image records" do
			before { @credit_duplicate.image_id = @image_2.reload.id }

			it "should be allowed" do
				expect { @credit.save }.
					to_not raise_error(ActiveRecord::RecordInvalid)

				expect { @credit_duplicate.save }.
					to_not raise_error(ActiveRecord::RecordInvalid)
			end
		end
	end

	describe "when having 2 Credit containing identical Image reference" do
		before do
			@credit_duplicate = Credit.new()
			@artist_1 = FactoryGirl.create(:artist)
			@artist_2 = FactoryGirl.create(:artist,
				artist_name: "Another Dude",
				page_link: "another_dude")
			@image = FactoryGirl.create(:image)

			@artist_1.save
			@artist_2.save
			@image.save

			@credit.artist_id = @artist_1.reload.id
			@credit.image_id = @image.reload.id

			@credit_duplicate.artist_id = @artist_1.reload.id
			@credit_duplicate.image_id = @image.reload.id
		end

		it ", they must not point to one Artist record" do
			expect { @credit.save }.
				to_not raise_error(ActiveRecord::RecordInvalid)

			expect { @credit_duplicate.save }.
				to raise_error(ActiveRecord::RecordNotUnique)
		end

		describe ", referencing multiple Artist records" do
			before { @credit_duplicate.artist_id = @artist_2.reload.id }

			it "should be allowed" do
				expect { @credit.save }.
					to_not raise_error(ActiveRecord::RecordInvalid)

				expect { @credit_duplicate.save }.
					to_not raise_error(ActiveRecord::RecordInvalid)
			end
		end
	end
end