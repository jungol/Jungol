class AddPendingToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :is_pending, :boolean, :null => false, :default => true
  end
end
