class CreateMedhubCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :medhub_courses do |t|
      t.string :course_code
      t.integer :course_id
      t.string :course_name
      t.timestamps
    end
    add_index :medhub_courses, :course_code
  end
end
