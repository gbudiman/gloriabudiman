class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer		:image_id
      t.integer		:artist_id
      t.timestamps
    end

    add_index :credits, :image_id
    add_index :credits, :artist_id
    add_foreign_key :credits, :image_id, :artist_id
  end
end
