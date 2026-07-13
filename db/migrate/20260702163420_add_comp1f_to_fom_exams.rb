class AddComp1fToFomExams < ActiveRecord::Migration[8.1]
  def change
    add_column :fom_exams, :comp6_mb, :decimal
  end
end
