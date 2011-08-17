class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.integer :user_id
      t.string :item_type
      t.integer :item_id

      t.timestamps
    end
  end
end
