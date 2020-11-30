class ChangeDatatypeForUserId < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :uid, :integer
  end
end
