class Medal < ActiveRecord::Base
  belongs_to :athlete
  belongs_to :event
  belongs_to :game
  attr_accessible :medal
  # attr_accessible :title, :body
end
