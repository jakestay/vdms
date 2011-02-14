class Meeting < ActiveRecord::Base
  belongs_to :faculty
  has_and_belongs_to_many :admits

  validates_datetime :time
  validates_presence_of :room
  validates_existence_of :faculty
end
