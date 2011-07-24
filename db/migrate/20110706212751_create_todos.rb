class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :creator_id
      t.integer :group_id
      t.string :title
      t.text :description

      t.timestamps
    end

    add_index :todos, :group_id
    add_index :todos, :creator_id
  end
end
