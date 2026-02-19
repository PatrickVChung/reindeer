class AddComp2aHss22toFomExam < ActiveRecord::Migration[7.2]
  def change
    add_column :fom_exams, :comp2a_hss22, :decimal
  end
end
