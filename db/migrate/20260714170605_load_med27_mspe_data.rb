require 'csv'
class LoadMed27MspeData < ActiveRecord::Migration[8.1]

  class MigrationMed27Mspe < ActiveRecord::Base
    self.table_name = :med27_mspes
  end

  def up
    csv_file = Rails.root.join("db", "med27_mspe_data.csv")
    return unless File.exist?(csv_file)

    records = []
    CSV.foreach(csv_file, headers: true) do |row|
      user = User.find_by(sid: row["sid"])
      records << {
        sid: row["sid"],
        email: row["email"],
        full_name: row["full_name"],
        user_id: user.id,
        permission_group_id: user.permission_group_id,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    # insert_all is lightning-fast and skips callbacks
    execute "TRUNCATE med27_mspes" # if clearing table first is preferred
    MigrationMed27Mspe.insert_all(records) if records.any?
  end

  def down
    execute "DELETE FROM med27_mspes;"
  end
end
