class AddUuidToLiveLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :live_lectures, :uuid, :string
    add_index :live_lectures, :uuid
  end
end
