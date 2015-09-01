class AddMobiPathToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :mobi_path, :string
  end
end
