class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description
      t.integer :todo_id
      t.integer :status
      t.integer :list_order
      t.integer :task_num

      t.timestamps
    end

    add_index :tasks, :todo_id
  end
end
