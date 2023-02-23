class CreateQuestionAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :question_answers do |t|
      t.text :answer_content, null: false
      t.references :user, null: false
      t.references :question, null: false

      t.timestamps
    end
  end
end
