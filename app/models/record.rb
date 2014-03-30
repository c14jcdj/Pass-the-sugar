class Record < ActiveRecord::Base
  TIME_LENIENCY = 600
  attr_accessible :weight, :glucose, :taken_at, :comment
  belongs_to :diabetic

  validate :inclusion_of_weight_and_or_glucose
  validate :taken_date_cannot_be_in_the_future
  validates_presence_of :taken_at
  validates_numericality_of :glucose, :weight



  def inclusion_of_weight_and_or_glucose
    unless (self.weight.present? || self.glucose.present?)
      errors.add(:weight, "Must include either weight or glucose")
      errors.add(:glucose, "Must include either weight or glucose")
    end
  end

  def taken_date_cannot_be_in_the_future
    if taken_at.present? && taken_at > (Time.now + TIME_LENIENCY)
      errors.add(:taken_at, "Date taken cannot be in the future")
    end
  end
end
