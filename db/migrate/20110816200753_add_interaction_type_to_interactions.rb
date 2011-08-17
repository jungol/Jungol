class AddInteractionTypeToInteractions < ActiveRecord::Migration
  def change
    add_column :interactions, :type, :string
  end
end
