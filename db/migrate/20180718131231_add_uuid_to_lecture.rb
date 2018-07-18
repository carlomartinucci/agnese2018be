class AddUuidToLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :uuid, :string
    add_index :lectures, :uuid
  end
end
