class AddVisibleToLecture < ActiveRecord::Migration[5.2]
  def change
    add_column :lectures, :visible, :boolean, default: false
  end
end
