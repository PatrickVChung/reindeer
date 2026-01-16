class AddCompetencyNoteToCourses < ActiveRecord::Migration[7.2]
  def change
    add_column :courses, :competency_note, :string
  end
end
