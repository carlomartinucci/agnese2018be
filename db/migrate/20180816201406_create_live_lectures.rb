class CreateLiveLectures < ActiveRecord::Migration[5.2]
  def change
    create_table :live_lectures do |t|
      t.references :lecture, foreign_key: true
      t.references :question, foreign_key: true
      t.string :state

      t.timestamps
    end
  end
end
