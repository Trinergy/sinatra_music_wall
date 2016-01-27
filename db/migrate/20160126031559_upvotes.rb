class Upvotes < ActiveRecord::Migration
  def change
    create_table :upvotes do |t|
      t.integer :votes
      t.references :music
      t.references :user
      t.timestamps null: false
    end
  end
end
