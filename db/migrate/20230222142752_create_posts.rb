class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :post_title, null: false
      t.text :post_content, size: :long, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
