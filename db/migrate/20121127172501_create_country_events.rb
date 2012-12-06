class CreateCountryEvents < ActiveRecord::Migration
  def change
    create_table :country_events do |t|
      t.references :event
      t.references :country
      t.references :game
      t.integer :gold
      t.integer :silver
      t.integer :bronze

      t.timestamps
    end
    add_index :country_events, :event_id
    add_index :country_events, :country_id
    add_index :country_events, :game_id
  end
end
