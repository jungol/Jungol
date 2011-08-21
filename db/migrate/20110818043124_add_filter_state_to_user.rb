class AddFilterStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :filter_state, :text
  end
end
