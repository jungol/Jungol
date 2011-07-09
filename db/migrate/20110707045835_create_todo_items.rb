class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.string :description
      t.integer :todo_id
      t.integer :status
      t.integer :list_order

      t.timestamps
    end

    add_index :todo_items, :todo_id
  end
end
