class DropMspeTables < ActiveRecord::Migration[7.1]
  def change
    # drop_table :med18_mspes
    # drop_table :med19_mspes
    # drop_table :med20_mspes
    # drop_table :med21_mspes
    # drop_table :med22_mspes
    # drop_table :med23_mspes
    # drop_table :med24_mspes
    # drop_table :med25_mspes
    # drop_table :med18_competencies
    # drop_table :med19_competencies
    # drop_table :med20_competencies
    # drop_table :med21_competencies
    #drop_table :competencies
    # drop_table :usmle_exams
    # drop_table :ume_blses
    # drop_table :preceptor_evals
    # drop_table :preceptor_assesses
    # drop_table :new_competencies
    # drop_table :messages
    # drop_table :med22_mspe_cces
    # drop_table :med22_fom_exams
    # drop_table :med21_fom_exams
    # drop_table :formative_feedbacks
    # drop_table :fom_remeds
    # drop_table :fom_labels
    # drop_table :fom_exams
    # drop_table :cpxes
    # drop_table :course_schedules
    # drop_table :courses
    # drop_table :csl_evals
    # drop_table :csl_feedbacks

    drop_table :meta_attribute_entity_groups
    drop_table :meta_attribute_groups
    drop_table :question_widgets
    drop_table :epas
    drop_table :epa_reviews
    drop_table :epa_masters
    drop_table :eg_reasons
    drop_table :eg_members
    drop_table :eg_cohorts
    drop_table :badging_dates


  end
end
