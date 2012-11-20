class CreateCountryGames < ActiveRecord::Migration
  def change
    create_table :country_games do |t|
      t.references :country
      t.references :game
      t.integer :gold
      t.integer :silver
      t.integer :bronze

      t.timestamps
    end
    add_index :country_games, :country_id
    add_index :country_games, :game_id
  end
end
