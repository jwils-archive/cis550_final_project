class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.references :sport
      t.timestamps
    end
    add_index :events, :sport_id
  end
end
