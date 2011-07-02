class CreateGroupGroupsJoinTable < ActiveRecord::Migration
  def up
    create_table :group_groups, :id => false do |t|
      t.integer :group_id
      t.integer :group2_id

    end
  end

  def down
    drop_table :group_groups
  end
end
