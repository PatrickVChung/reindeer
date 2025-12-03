class CreateUmeAssessPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :ume_assess_plans do |t|
      t.string :year
      t.string :competency
      t.string :student_learning_objective
      t.string :assessment_description
      t.string :method
      t.string :target
      t.string :resource
      t.boolean :target_met
      t.string :target_results
      t.boolean :rubric_used 
      t.timestamps
    end
  end
end
