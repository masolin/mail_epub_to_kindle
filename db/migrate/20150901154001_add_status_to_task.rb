class AddStatusToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :status, :integer, default: 0
    add_index :tasks, :status
  end
end
