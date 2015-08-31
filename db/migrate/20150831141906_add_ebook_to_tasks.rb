class AddEbookToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :ebook, :string
  end
end
