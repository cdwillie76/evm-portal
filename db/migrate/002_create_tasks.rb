class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :name
      t.date :start_date, :end_date
      t.integer :budget
      t.references :project, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
