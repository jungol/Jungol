class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.integer :creator_id
      t.integer :group_id
      t.string :title
      t.text :body

      t.timestamps
    end

    add_index :discussions, :creator_id
    add_index :discussions, :group_id
  end
end
