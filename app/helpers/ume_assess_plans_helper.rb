module UmeAssessPlansHelper

  def hf_create_text_file(in_file)
    file_path = Rails.root.join("tmp", in_file)
    CSV.open(file_path, "wb") do |csv|
      csv << UmeAssessPlan.attribute_names.map{|h| h.titleize}
      UmeAssessPlan.find_each do |ume|
        csv << ume.attributes.values
      end
    end
    return file_path
  end
end
