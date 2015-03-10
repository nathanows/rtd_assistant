class DirectionSet < ActiveRecord::Base
  belongs_to :location
  has_many :routes
end
