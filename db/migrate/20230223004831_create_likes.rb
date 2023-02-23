class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false
      t.references :question_answer, null: false

      t.timestamps
    end
  end
end
