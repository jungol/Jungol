class DestroyGroupGroupsJoinTable < ActiveRecord::Migration
  def change
    drop_table :group_groups
  end
end
