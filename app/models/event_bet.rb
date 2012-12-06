class EventBet < ActiveRecord::Base
  belongs_to :country
  attr_accessible :amount, :event, :user
end
