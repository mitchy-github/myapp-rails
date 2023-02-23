class CreateCategoryUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :category_users do |t|
      t.references :user, null: false
      t.references :category, null: false

      t.timestamps
    end
  end
end
