class CreateResumes < ActiveRecord::Migration[5.0]
  def change
    create_table :resumes do |t|
      t.integer :position_id
      t.integer :personnel_id
      t.integer :schedule_id
    end
  end
end
