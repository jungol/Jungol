class RenameInteractionTypetoActionType < ActiveRecord::Migration
  def up
    rename_column :interactions, :type, :summary
  end

  def down
    rename_column :interactions, :summary, :type
  end
end