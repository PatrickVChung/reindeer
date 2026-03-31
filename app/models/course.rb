class Course < ApplicationRecord
  has_many :course_schedules, dependent: :destroy

  # scope :with_categories, ->(cats[]) { where(category: cats[]) if cats[].present }
  # scope :with_departments, ->(depts) { where(department: depts) if depts.present}
  # scope :with_durations, ->(weeks) { where(duration: weeks) if weeks.present }
  # app/models/course.rb
  scope :search, ->(term) {
    where(
      "course_number ILIKE :q OR course_name ILIKE :q OR course_purpose_statement ILIKE :q",
      q: "%#{term}%"
    )
  }

  scope :available_and_has_comment, -> {
    joins(:course_schedules)
      .where.not(course_schedules: { no_of_seats: [0, nil] })
      .or(
        joins(:course_schedules)
          .where(course_schedules: { no_of_seats: [0, nil] })
          .where.not(course_schedules: { comment: nil })
      ).distinct
  }


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
