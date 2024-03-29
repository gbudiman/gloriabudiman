class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string		:username
    	t.string		:email
    	t.integer		:level
    	t.string		:password_digest
		t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_foreign_key :users, :artist_id
  end
end
