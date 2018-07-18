class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :lecture_id
      t.string :uuid
      t.string :title
      t.string :answer_a
      t.string :answer_b
      t.string :answer_c
      t.string :answer_d
      t.string :answer_e
      t.string :right_answer_letter

      t.timestamps
    end
    add_index :questions, :lecture_id
    add_index :questions, :uuid
  end
end
