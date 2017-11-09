class CreatePersonnelsPositions < ActiveRecord::Migration[5.0]
  def change
    create_table :personnels_positions, id: false do |t|
      t.belongs_to :personnel, index: true
      t.belongs_to :position, index: true
    end
  end
end