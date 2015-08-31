class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :email

      t.timestamps null: false
    end
  end
end
