class CreateCategoryQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :category_questions do |t|
      t.references :question, null: false
      t.references :category, null: false

      t.timestamps
    end
  end
end
