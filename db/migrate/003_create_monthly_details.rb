class CreateMonthlyDetails < ActiveRecord::Migration
  def self.up
    create_table :monthly_details do |t|
      t.date :date
      t.integer :planned_complete_in_dollars, :actual_completed_in_dollars, :actual_spent_in_dollars
      t.references :task, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :monthly_details
  end
end
