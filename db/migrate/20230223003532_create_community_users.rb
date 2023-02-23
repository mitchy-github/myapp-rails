class CreateCommunityUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :community_users do |t|
      t.references :user, null: false
      t.references :community, null: false

      t.timestamps
    end
  end
end
