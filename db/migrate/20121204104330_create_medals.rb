class CreateMedals < ActiveRecord::Migration
  def change
    create_table :medals do |t|
      t.references :athlete
      t.references :event
      t.references :game
      t.string :medal

      t.timestamps
    end
    add_index :medals, :athlete_id
    add_index :medals, :event_id
    add_index :medals, :game_id
  end
end
