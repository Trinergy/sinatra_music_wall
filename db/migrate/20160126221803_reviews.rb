class Reviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :subject
      t.string :comment
      t.integer :rating
      t.references :user
      t.references :music
      t.timestamps null: false
    end
  end
end
