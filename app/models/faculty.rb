class Faculty < Person
  ATTRIBUTES = Person::ATTRIBUTES.merge({
    'Area' => :area,
    'Division' => :division,
    'Schedule' => :schedule,
    'Default Room' => :default_room,
    'Max Admits Per Meeting' => :max_admits_per_meeting,
    'Max Additional Admits' => :max_additional_admits
  })
  serialize :schedule, Array

  def after_initialize
    if new_record? # work around for bug 3165
      self.schedule ||= []
      self.default_room ||= 'None'
      self.max_admits_per_meeting ||= 1
      self.max_additional_admits ||= Float::MAX.to_i
    end
  end

  validates_presence_of :area
  validates_presence_of :division
  validates_presence_of :default_room
  validates_presence_of :max_admits_per_meeting
  validates_numericality_of :max_admits_per_meeting, :only_integer => true, :greater_than => 0
  validates_presence_of :max_additional_admits
  validates_numericality_of :max_additional_admits, :only_integer => true, :greater_than_or_equal_to => 0

  has_many :admit_rankings
  has_many :meetings

=begin
  Draft of helper method to achieve symmetry with Admits (pending RSpec tests)

  def available_times
    schedule.inject {|result, s| result + s[:times]}
  end
=end
end
