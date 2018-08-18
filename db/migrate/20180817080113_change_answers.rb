class ChangeAnswers < ActiveRecord::Migration[5.2]
  def change
    rename_column :answers, :email, :user_slug
  end
end
