class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :year
      t.string :season

      t.timestamps
    end
  end
end
