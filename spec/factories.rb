FactoryGirl.define do
	factory :user do
		username				"Gloria Budiman"
		email					"wahyu.g@gmail.com"
		level					"8"
		password				"579316842"
		password_confirmation 	"579316842"
	end

	factory :artist do
		artist_name				"Gloria Budiman"
		page_link				"gbudiman"
		user_id					1
	end

	factory :image do
		image_link				"http://some.hosting.com/link_1.jpg"
	end
end