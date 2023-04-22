class CreateUserRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :user_rooms do |t|
      t.bigint :user_id
      t.bigint :room_id

      t.timestamps
    end
  end
end
