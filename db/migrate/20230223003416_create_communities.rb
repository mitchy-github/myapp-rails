class CreateCommunities < ActiveRecord::Migration[7.0]
  def change
    create_table :communities do |t|
      t.string :community_name, null: false
      t.text :community_explanation_column, null: false
      t.string :community_image

      t.timestamps
    end
  end
end
