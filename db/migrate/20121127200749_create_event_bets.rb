class CreateEventBets < ActiveRecord::Migration
  def change
    create_table :event_bets do |t|
      t.references :user
      t.references :event
      t.references :country
      t.decimal :amount

      t.timestamps
    end
    add_index :event_bets, :country_id
    add_index :event_bets, :user_id
  end
end
