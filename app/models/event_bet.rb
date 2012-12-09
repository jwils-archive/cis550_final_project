class EventBet < ActiveRecord::Base
  belongs_to :country
  belongs_to :user
  belongs_to :event
  attr_accessible :amount
end
