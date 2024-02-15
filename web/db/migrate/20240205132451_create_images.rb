class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.belongs_to :collection, foreign_key: true
      t.string :checksum
      t.string :url
      t.boolean :public
      t.timestamps
    end
  end
end
