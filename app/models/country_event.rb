class CountryEvent < ActiveRecord::Base
  belongs_to :event
  belongs_to :country
  belongs_to :game
  attr_accessible :bronze, :gold, :silver
end
