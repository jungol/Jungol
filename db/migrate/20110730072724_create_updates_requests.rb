class CreateUpdatesRequests < ActiveRecord::Migration
  def change
    create_table :updates_requests do |t|
      t.string :email
      t.string :ip

      t.timestamps
    end
    add_index :updates_requests, :email, :unique => true
  end
end
