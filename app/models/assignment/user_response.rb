class Assignment::UserResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_assignment
  has_many :assignment_comments
  delegate :user, to: :user_assignment

  def assignment_group
    user_assignment.survey_assignment.assignment_group
  end

end
