class CreateGroupConnections < ActiveRecord::Migration
  def change
    create_table :group_connections do |t|
      t.integer :group_id
      t.integer :group_b_id
      t.integer :status, :null => false, :default => 0

      t.timestamps
    end

    add_index :group_connections, :group_id
    add_index :group_connections, :group_b_id
  end

end
