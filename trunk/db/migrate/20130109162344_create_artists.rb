class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string		:artist_name
      t.string		:page_link
      t.integer		:user_id
      t.timestamps
    end

    add_index :artists, :artist_name, unique: true
    add_index :artists, :page_link, unique: true
    add_foreign_key :artists, :user_id
  end
end
