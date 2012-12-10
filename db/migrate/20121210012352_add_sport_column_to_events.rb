class AddSportColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :sport, :string
  end
end
