class UseEmailInsteadOfUserUidInAnswer < ActiveRecord::Migration[5.2]
  def change
    rename_column :answers, :user_uid, :email
  end
end
