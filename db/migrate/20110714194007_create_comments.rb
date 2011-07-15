class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.text :body
      t.string :item_type
      t.integer :item_id

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :item_id
  end
end
