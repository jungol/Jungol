class CreateItemShares < ActiveRecord::Migration
  def change
    create_table :item_shares do |t|
      t.integer :item_id
      t.string  :item_type
      t.integer :group_id
      t.integer :creator_id
      t.boolean :admins_only, :null => false, :default => false

      t.timestamps
    end

    add_index :item_shares, :item_id
    add_index :item_shares, :group_id
    add_index :item_shares, :creator_id
  end
end
