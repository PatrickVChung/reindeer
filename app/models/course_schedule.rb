class CourseSchedule < ApplicationRecord
  validates :course_id, :year, :block, :start_date, :end_date, :no_of_seats, presence: true
  belongs_to :course, optional: false  # want the activerecord to enforce the association integrity

  COMP_CODES = ["ics1", "ics2", "ics3", "ics4", "ics5", "mk1", "mk2", "mk3", "pbli1", "pbli2", "pbli3", "pcp1", "pcp2", "pcp3", "pppd1", "pppd2",  "sbp1"]

  def self.comp_codes
    return COMP_CODES.map(&:upcase)
  end
end
