class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :sex, null: false
      t.date :birthday, null: false
      t.string :region, null: false
      t.integer :number_of_baby
      t.date :birthday_of_baby
      t.date :childcare_start
      t.date :childcare_graduation_start
      t.date :childcare_graduation_end
      t.boolean :child_want
      t.integer :months_pregnant
      t.string :password_digest, null: false
      t.string :remember_digest
      t.boolean :admin, null: false, default: false
      t.string :activation_digest, null: false
      t.boolean :activated, null: false, default: false
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at

      t.timestamps
    end
  end
end
