class CreatePersonnels < ActiveRecord::Migration[5.0]
  def change
    create_table :personnels do |t|
      t.string :name
    end
  end
end
