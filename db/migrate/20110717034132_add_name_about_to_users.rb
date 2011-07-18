class AddNameAboutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :about, :text
  end
end
