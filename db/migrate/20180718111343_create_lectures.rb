class CreateLectures < ActiveRecord::Migration[5.2]
  def change
    create_table :lectures do |t|
      t.string :title
      t.datetime :delivered_at
      t.string :tutor
      t.text :description

      t.timestamps
    end
  end
end
