class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :about
      t.integer :creator_id

      t.timestamps
    end
      add_index :groups, :creator_id
  end
end
