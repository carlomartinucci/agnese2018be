class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.string :user_uid
      t.string :question_uuid
      t.string :letter

      t.timestamps
    end
    add_index :answers, :user_uid
    add_index :answers, :question_uuid
  end
end
