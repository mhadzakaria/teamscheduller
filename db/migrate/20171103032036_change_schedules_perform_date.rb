class ChangeSchedulesPerformDate < ActiveRecord::Migration[5.0]
  def up
    change_table :schedules do |t|
      t.change :perform_date, :datetime
    end
  end
 
  def down
    change_table :schedules do |t|
      t.change :perform_date, :date
    end
  end
end