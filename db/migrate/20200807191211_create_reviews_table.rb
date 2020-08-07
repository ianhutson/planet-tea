class CreateReviewsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :reviews do |t|
      t.text :name
      t.text :color
      t.text :flavor
      t.text :tea_type
      t.text :country
      t.text :supplier
      t.text :notes
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
