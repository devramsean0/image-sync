class CreateCollections < ActiveRecord::Migration[7.1]
  def change
    create_table :collections do |t|
      t.string :name
      t.string :S3_folder_path
      t.string :slug
      t.boolean :public
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
