class Athlete < ActiveRecord::Base
  belongs_to :sport
  belongs_to :country
  attr_accessible :DOB, :full_name, :gender
end
