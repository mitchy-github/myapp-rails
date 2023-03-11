class ChangeColumnToNull < ActiveRecord::Migration[7.0]
  def up
    # Not Null制約を外す場合　not nullを外したいカラム横にtrueを記載
    change_column_null :users, :activation_digest, true
  end
    
  def down
    change_column_null :users, :activation_digest, false
  end
end
