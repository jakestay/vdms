class Settings < ActiveRecord::Base
  include Singleton

  def after_initialize
    if self.new_record?
      self.unsatisfied_admit_threshold ||= 0
      self.faculty_weight ||= 1
      self.admit_weight ||= 1
      self.rank_weight ||= 1
      self.mandatory_weight ||= 1
      self.disable_faculty ||= false
      self.disable_peer_advisors ||= false
    end
  end
  after_save do |record|
    if record.divisions.empty?
      STATIC_SETTINGS['divisions'].each_key {|name| record.divisions.create(:name => name)}
    end
  end

  has_many :divisions, :order => 'name ASC', :dependent => :destroy
  accepts_nested_attributes_for :divisions

  validates_presence_of :unsatisfied_admit_threshold
  validates_numericality_of :unsatisfied_admit_threshold, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :faculty_weight, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :admit_weight, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :rank_weight, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :mandatory_weight, :only_integer => true, :greater_than_or_equal_to => 0
  validates_inclusion_of :disable_faculty, :in => [true, false]
  validates_inclusion_of :disable_peer_advisors, :in => [true, false]

  def self.instance
    self.find(:all).first || self.send(:create)
  end

  def meeting_times(division_name)
    division = self.divisions.find_by_name(division_name)
    division.nil? ? nil : division.available_times
  end

  def method_missing(method, *args, &block)
    STATIC_SETTINGS[method.to_s] || super
  end
end
