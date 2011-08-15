class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :creator_id
      t.integer :group_id
      t.string :title
      t.text :description

      t.string :doc_file_name
      t.string :doc_content_type
      t.integer :doc_file_size
      t.datetime :doc_updated_at

      t.timestamps
    end

    add_index :documents, :creator_id
    add_index :documents, :group_id

  end
end
