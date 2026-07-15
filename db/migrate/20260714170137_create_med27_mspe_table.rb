class CreateMed27MspeTable < ActiveRecord::Migration[8.1]
  def change
    create_table :med27_mspes do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :permission_group_id
      t.string :sid
      t.string :email
      t.string :full_name
      t.timestamps
    end
  end
end
