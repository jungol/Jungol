class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :creator_id
      t.integer :group_id
      t.string :title
      t.text :description
      t.integer :tasks_count, :default => 0

      t.timestamps
    end

    add_index :todos, :group_id
    add_index :todos, :creator_id
  end
end
