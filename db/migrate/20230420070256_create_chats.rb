class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.bigint :user_id
      t.bigint :room_id
      t.text :message

      t.timestamps
    end
  end
end
