class Course < ApplicationRecord
  has_many :course_schedules, dependent: :destroy

  # scope :with_categories, ->(cats[]) { where(category: cats[]) if cats[].present }
  # scope :with_departments, ->(depts) { where(department: depts) if depts.present}
  # scope :with_durations, ->(weeks) { where(duration: weeks) if weeks.present }

# Add more scopes for filtering

  def self.competencies_count
    comp_count = {}
    CourseSchedule.comp_codes.each do |comp|
      #c_count = Course.where("competencies @> ?", "{#{comp}}")
      comp_count[comp]  = Course.where("competencies @> ?", "{#{comp}}").count
    end
    return comp_count
  end

end
