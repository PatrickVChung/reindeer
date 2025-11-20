module CreatePdfsHelper

  HEADER1 = "Med28 Formative Feedback NSF CSA"

  HEADER2 = "Thank you for taking the time to provide important feedback to the students on their third Clinical Skills Assessment (CSA). Please
watch the recorded encounter for each student in SimCapture (using the instructions provided separately), then provide feedback on
their history taking, examination, and discussion skills in this survey.
Your responses will help students prepare for their clinical experiences"
  HEADER3 = "Your responses will help students prepare for their clinical experiences and help meet our LCME requirement to provide students with
formative feedback to facilitate positive change during this Foundations of Medicine Block."

  def hf_header1
    return HEADER1
  end

  def hf_header2
    return HEADER2
  end
  def hf_header3
    return HEADER3
  end

  def replace_special_chars(in_str)
    if in_str.to_s == ""
      return ""
    else
      out_str = in_str.force_encoding("UTF-8")
      #out_str = in_str.gsub("Â", "").gsub("â€™", "'").gsub("â€œ", '"').gsub('â€“', '-').gsub('â€', '"')
      #out_str = in_str.gsub("\xE2\x80\x9C", '"').gsub("\xE2\x80\x9D", '"').gsub("\xE2\x80\x99", "'")
      return out_str
    end
  end

  def format_date(in_date)
    temp_date = in_date.split("/")
    return temp_date[2] + "/" + temp_date[0] + "/" + temp_date[1]
  end

  def process_qualtrics(user, block_code, row, part_file, tmp_path, header1, header2, header3)

   full_name = user.full_name.gsub(", ", "_")
   #path_file = "/home/patrick/source/reindeer/tmp/Informatics_CSA"
   tmp_path = tmp_path.to_s # need to convert to string otherwise, it will not work for Prawn
   file_name = "#{tmp_path}/#{full_name}_#{part_file}.pdf"

   Prawn::Document.generate("#{file_name}") do |pdf|

      pdf.font "Times-Roman", :size => 12
      pdf.text "#{header1}", :style => :bold
      pdf.font_size 10
      pdf.text "#{header2}"
      pdf.text " "
      pdf.text "#{header3}"
      pdf.text " "
      pdf.stroke_horizontal_rule
      pdf.text " "

      pdf.font_size 10
      pdf.font "Courier" #, :size => 12"
      pdf.text "Student Name  : #{user.full_name}", :style => :bold, :color => "0000ff"
      pdf.text "Student UID   : " + user.sid, :style => :bold, :color => "0000ff"
      pdf.text "Student email : " + user.email, :style => :bold, :color => "0000ff"
      pdf.text "FoM Block     : " + block_code, :style => :bold, :color => "0000ff"
      pdf.text "Recorded Date : " + row["Recorded Date"], :style => :bold, :color => "0000ff"
      pdf.text "Response ID   : " + row["Response ID"], :style => :bold, :color => "0000ff"
      pdf.text "Evaluator     : " + row["Evaluator Name"], :style => :bold, :color => "0000ff"
      pdf.text " "
      pdf.stroke_horizontal_rule
      pdf.text " "

      pdf.font "Times-Roman" #, :size => 12"
      row.drop(4).each do |key, val|
        pdf.text "Question: " + key
          pdf.text "Ans/Comment: " + replace_special_chars(val), :color => "0000ff"
        pdf.text " "
      end
    end
    # attached to user account
    student_file_name = "#{full_name}_#{part_file}.pdf"
    #try to locate where the artifact exists, if exists, try to find any attachments to the artifact
    #if attachment does exist with the same student_file_name, it will replace it.
    artifact = Artifact.where(title: 'FoM', content: block_code, user_id: user.id).first
    not_found = true
    if !artifact.nil?
      if artifact.documents.attached?
        artifact.documents.each do |document|
          if document.filename.to_s == student_file_name
            document.purge
            if !artifact.documents.attached?  ## no attached files
              artifact.documents.attach(io: File.open(file_name), filename: student_file_name, content_type: "application/pdf")
            else
              #it has attached files.
              artifact.documents.attach(io: File.open(file_name), filename: student_file_name, content_type: "application/pdf")
            end
            not_found = false
            break
          end
        end
        #we need attach the pdf to the last item
        if not_found
            artifact.documents.attach(io: File.open(file_name), filename: student_file_name, content_type: "application/pdf")
        end
      else
        artifact.documents.attach(io: File.open(file_name), filename: student_file_name, content_type: "application/pdf")
      end
    else
      artifact = Artifact.create(title: 'FoM', content: block_code, user_id: user.id) do |a|
       a.documents.attach(io: File.open(file_name), filename: student_file_name, content_type: "application/pdf")
      end
    end

    return student_file_name

  end
  def hf_create_and_move(artifact_id, block_code, part_filename, header1, header2, header3)
    folder_name = "Informatics_CSA"
    tmp_path = Rails.root.join("tmp", folder_name)
    # Check if the folder exists
    unless File.directory?(tmp_path)
      # If it doesn't exist, create it
      FileUtils.mkdir_p(tmp_path)
      #puts "Created directory: #{tmp_path}"
    end
    pdf_log = []
    artifact = Artifact.find(artifact_id)
    CSV.parse(ActiveStorage::Attachment.find(artifact.documents.first.id).download, headers: true, col_sep: "\t") do |row|
      email = row["Student Name"].split(" - ").last
      user = User.find_by(email: email)
      student_file_name = process_qualtrics(user, block_code, row, part_filename, tmp_path, header1, header2, header3)
      pdf_log.push student_file_name
    end
    return pdf_log
  end

end
