class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.references :user, null: false, foreign_key: true
      t.text :image_data

      t.timestamps
    end
  end
end
