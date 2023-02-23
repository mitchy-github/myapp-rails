class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :question_title, null: false
      t.text :contents_question, null: false
      t.string :questioners_region, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
