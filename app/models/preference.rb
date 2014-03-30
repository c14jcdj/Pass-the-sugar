class Preference < ActiveRecord::Base

  attr_accessible :reminders, :frequency
  belongs_to :diabetic
  validates_numericality_of :frequency, :allow_nil => true, :greater_than_or_equal_to => 0

end