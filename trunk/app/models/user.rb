# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)
#  email           :string(255)
#  level           :integer
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
	has_one :artist, dependent: :nullify
	attr_accessible :username, 
					:email, 
					:password, 
					:password_confirmation,
					:level,  
					:password_digest
	has_secure_password
	before_save { self.email.downcase! }
	before_save do
		if self.level == nil
			self.level = 1
		end
	end

	VALID_USERNAME_REGEX = /^[\w\-\s]+$/
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :username, presence: true, 
					format:  		{ with: VALID_USERNAME_REGEX },
					length: 		{ minimum: 4, maximum: 32 },
					uniqueness: 	{ case_sensitive: true }
	validates :email, presence: true, 
					format: 		{ with: VALID_EMAIL_REGEX },
					uniqueness: 	{ case_sensitive: false }
	validates :level, numericality: true, inclusion: 1..8
	validates :password, presence: true, length: { minimum: 6, maximum: 32 }
	validates :password_confirmation, 
					presence: true,
					length: { minimum: 6, maximum: 32 }
end
