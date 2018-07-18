class AddUserToLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :user_id, :integer
    add_index :lectures, :user_id
  end
end
