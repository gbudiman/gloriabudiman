class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer		:credit_id
      t.string		:image_link
      t.string		:facebook_link
      t.string		:gplus_link
      t.boolean		:is_commercial
      t.boolean		:is_filtered
      t.boolean 	:is_front_page
      t.boolean		:is_published
      t.integer		:view_count
      t.timestamps
    end

    add_index :images, :credit_id, unique: true
    add_index :images, :image_link, unique: true
    add_index :images, :facebook_link, unique: true
    add_index :images, :gplus_link, unique: true
    add_foreign_key :images, :credit_id
  end
end
