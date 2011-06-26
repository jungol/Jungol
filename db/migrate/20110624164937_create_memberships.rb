class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :role

      t.timestamps
    end

    add_index :memberships, :user_id
    add_index :memberships, :group_id
    add_index :memberships, :role
  end
end
