class CreateAthletes < ActiveRecord::Migration
  def change
    create_table :athletes do |t|
      t.string :full_name
      t.string :gender
      t.string :DOB
      t.references :sport
      t.references :country

      t.timestamps
    end
    add_index :athletes, :sport_id
    add_index :athletes, :country_id
  end
end
