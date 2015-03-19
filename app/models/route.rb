class Route < ActiveRecord::Base
  belongs_to :direction_set
  has_many :steps
end
