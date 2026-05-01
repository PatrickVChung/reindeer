class AddEnrollmentInstructionsToCourse < ActiveRecord::Migration[7.2]
  def change
    add_column :courses, :enrollment_instructions, :string
    add_column :courses, :admin_notes, :string
    rename_column :courses, :category, :course_type
    change_column_default :courses, :grading_method, from: nil, to: "Pass/No Pass"
    add_index :courses, [:course_type, :course_number]
  end
end
