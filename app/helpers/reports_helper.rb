module ReportsHelper

  # updated on 2/27/2025
  NEW_EPA_KEYWORDS = {
  "EPA1A" => ["histories", "hypothesis-driven history", "hypothesis driven history", "targeted history", "focused history", "directed history", "history taking", "medical history", "patient history", "clinical history", "history of present illness", "HPI", "review of systems", "ROS", "past medical history", "PMH", "interview", "information gathering"],
  "EPA1B" => ["physical exams", "physical exam", "physical examination", "examinations", "targeted exam", "focused physical", "directed physical", "tailored exam", "tailored physical", "clinical exam", "physical assessment", "body systems", "mental status", "H and P", "H&P"],
  "EPA2" => ["differential diagnosis", "prioritized differential", "differential", "ddx", "diagnosis", "prioritized list", "diagnostic possibilities", "rule out", "problem list", "clinical impression", "impression", "problem formulation"],

  "EPA3" => ["management plan", "management plans", "assessment and plans", "assessment and plan","interpret", "interpretation", "diagnostic testing", "screening test", "laboratory test", "lab test", "labs", "imaging", "test result", "diagnostic study", "radiology", "x-ray", "CT", "ultrasound", "MRI", "EKG", "ECG", "test interpretation", "normal values", "diagnostic assessment"],

  "EPA4" => ["orders", "order entry", "ordering", "prescription", "prescribe", "medication order", "drug order", "lab order", "imaging order", "test order", "consult order", "consultation request", "order set", "dosing", "dose", "frequency", "route", "duration", "refill", "e-prescribe"],

  "EPA5" => ["documentation", "medical record", "EMR", "EHR", "chart note", "written notes", "note", "notes" "progress note", "SOAP note", "H&P", "history and physical", "written documentation", "admission note", "discharge summary", "procedure note", "clinic note", "inpatient note", "outpatient note", "consult note", "consultation note", "patient record"],

  "EPA6" => ["presentation", "presentations", "oral presentation", "case presentation", "clinical presentation", "patient presentation", "report", "verbal report", "bedside presentation", "presenting patient", "rounds presentation"],

  "EPA7" => ["literature", "evidence", "literature search", "evidence-based medicine", "EBM", "research", "clinical question", "PICO", "clinical evidence", "journal", "publication", "guideline", "clinical guideline", "systematic review", "meta-analysis", "randomized controlled trial", "RCT", "medical literature", "PubMed", "literature review", "clinical application"],

  "EPA8" => ["handover", "handoff", "hand-off", "sign out", "sign-out", "transition of care", "transfer of care", "patient transfer", "I-PASS", "SBAR", "transfer of information", "continuity of care", "care transition", "shift change", "coverage", "cross-coverage", "signout", "hand over", "pass the baton", "transfer of responsibility"],

  "EPA9" => ["interprofessional", "collaboration", "team-based care", "multidisciplinary", "interdisciplinary", "healthcare team", "care team", "team communication", "consultation", "nurse", "pharmacist", "social worker", "case manager", "physical therapist", "occupational therapist", "respiratory therapist", "team approach", "care coordination", "coordinated care", "team member"],

  "EPA10" => ["urgent", "emergent", "emergency", "critical", "rapid response", "code", "code blue", "deterioration", "unstable", "escalation", "escalate care", "decompensation", "triage", "patient safety", "immediate intervention", "life-threatening", "critical situation", "acute change", "resuscitation", "CPR", "ACLS", "BLS"],

  "EPA11" => ["shared decision making", "shared decision-making", "informed consent", "patient preference", "treatment options", "patient values", "risk communication", "benefit-risk", "risks and benefits", "patient autonomy", "patient education", "decision aid", "informed choice", "patient-centered", "patient centered", "preference-sensitive", "decision support", "joint decision"]
}

  NEW_EPA_COLORS = {
    "EPA1A" => "#4AC24E",  #green shade
    "EPA1B" => "#2B22AA", # indigo
    "EPA2" => "#282CC2", # blue shade
    "EPA3" => "#8A18C2", # purple shade
    "EPA4" => "#ffc34d", # gold color
    "EPA5" => "#C21508", # red shade
    "EPA6" => "#FF00FF", # fushia
    "EPA7" => "#800000", # Maroon
    "EPA8" => "#7F00FF", # violet
    "EPA9" => "#72c2ce", # darker lightblue
    "EPA10" => "#FF7F50", # coral
    "EPA11" => "#40E0D0" # Turquoise
  }

  NEW_EPA_CODES = ["EPA1A", "EPA1B", "EPA2", "EPA3", "EPA4", "EPA5", "EPA6", "EPA7", "EPA8", "EPA9", "EPA10", "EPA11"]
  CORE_CODES = ["FAMP", "IMED", "NEUR", "OBGY", "PEDI", "PSYC", "SURG"]

  BLOCKS = ['1-FUND', '2-BLHD', '3-SBM', '4-CPR', '5-HODI', '6-NSF', '7-DEVH']

  WHERE_QUERY =
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? '
  WHERE_QUERY2 =
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? '


  def hf_core_codes
    return CORE_CODES
  end

  def average_summary(summary_data, user)
    student_hash = {}
    student_hash.store('Student', user.full_name)
    student_hash.store('Email', user.email)
    total_score = 0.0
    average = 0.0

    BLOCKS.each do |block|
      found_block = summary_data.select{|s| s['course_code'] if s['course_code'] == block}
      if !found_block.empty?
        student_hash.store(found_block.first['course_code'] + ' Summary', found_block.first['average'].to_f)
        total_score += found_block.first['average'].to_f
      else
        student_hash.store(block + ' Summary', 0.0)
      end
    end

    no_of_blocks = summary_data.count
    average = total_score/7.0 #if no_of_blocks != 0
    student_hash.store('Cumulative FoM Average', average.round(2))
    return student_hash
  end

  def hf_get_ranking(users)
    data_array = []
    data_hash = {}
    users.each do |user|
      if user.username != 'bettybogus'
        summary_data = FomExam.execute_sql("select id, user_id, course_code, summary_comp1, summary_comp2a, summary_comp2b,
                        summary_comp3, summary_comp4, summary_comp5a, summary_comp5b,
                        ROUND((SUMMARY_COMP1+SUMMARY_COMP2A+SUMMARY_COMP2B+SUMMARY_COMP3+SUMMARY_COMP4+SUMMARY_COMP5A+SUMMARY_COMP5B)/7::numeric,2) AS Average
                        from fom_exams where user_id=#{user.id} order by course_code").to_a

          data_hash = average_summary(summary_data, user)
          data_array.push data_hash
      end
    end
    #data_array = data_array.sort_by{ |d| d['Cumulative FoM Average']}.reverse!
    # to sort the average in descending order - done in jquery using dataTables features
    return data_array
  end

  def model_exists? (model_name)
    files = Dir[Rails.root + 'app/models/*.rb']
    models = files.map{ |m| File.basename(m, '.rb').camelize }
    if models.include? model_name
      return true
    else
      return false
    end
  end

  def hf_student_list(permission_group_id)
    permission_group_title = PermissionGroup.find(permission_group_id.to_i).title.split(' ').last.gsub(/[()]/, '')
    mspeTable = "#{permission_group_title}Mspe"
    if model_exists? mspeTable
      student_list = mspeTable.constantize.all.order(:full_name).collect{|s| [s["full_name"], s["email"]]}.unshift(["All", "All"])
    else
      permission_group = PermissionGroup.where("title like ?","%#{permission_group_title}%")
      student_list = User.where(permission_group_id: permission_group.first.id).order(:full_name).collect{|s| [s["full_name"], s["email"]]}.unshift(["All", "All"])
    end
  end

  def hf_get_mspe_data_by_email(email, permission_group_id)
    permission_group_title = PermissionGroup.find(permission_group_id.to_i).title.split(' ').last.gsub(/[()]/, '')
    mspeTable = "#{permission_group_title}Mspe"
    mspe_data = []
    if model_exists? (mspeTable)
      mspe = mspeTable.constantize.find_by(email: email).competencies.where(WHERE_QUERY, '%FoM%', '%JCON%', '%TRAN%', '%PREC 724%', '%SCHI%', '%CPX 702%', '%FAMP 705SD%', '%GMED 705AB%',
      '%IMEDMINF 705B%', '%MULT 705A%', '%MULT 705C%', '%MULT 705D%', '%MULT 705TI%', '%709Z%').select(:id, :student_uid, :user_id, :email,
        :course_id, :course_name, :final_grade, :start_date, :end_date, :submit_date, :evaluator, :prof_concerns, :mspe,
      ).order(:user_id, :start_date)
      mspe_data.push mspe
      file_name = create_tab_delimited_file(permission_group_title, email, mspe_data)
      return mspe_data, file_name
    else
      return mspe_data.push "Table #{mspeTable} is Not Created/Loaded Yet!"
    end
  end

  def create_tab_delimited_file(permission_group_title, email, mspe_data)
    full_name = User.find_by(email: email).full_name.gsub(", ", "_") if email != 'All'
    full_name = 'All' if email == 'All'

    file_name = "#{Rails.root}/tmp/#{permission_group_title}_#{full_name}_mspe_data.txt"

    CSV.open(file_name,'wb', col_sep: "\t") do |csvfile|

      header =  mspe_data.first.first.attributes.keys  ##map{|c| c.titleize}
      header.unshift("Full Name")  ## insert in the beginning of array
      csvfile << header
      mspe_data.each do |data|
        data.each do |sub_data|
          final_hash = JSON.parse(sub_data["final_grade"] )
          sub_data["final_grade"] = final_hash["Grade"]
          full_name = User.find(sub_data.user_id).full_name
          print_data = sub_data.attributes.values
          print_data.unshift(full_name)
          csvfile << print_data
        end
      end
    end
    return File.basename(file_name)

  end

  def hf_get_mspe_data (permission_group_id)
    permission_group_title = PermissionGroup.find(permission_group_id.to_i).title.split(' ').last.gsub(/[()]/, '')
      # query_select = ':student_uid, :user_id, :users.permission_group_id, :competencies.email, ' +
      #   ':course_id, :course_name, :final_grade, :start_date, :end_date, :submit_date, :evaluator, ' +
      #   ':prof_concerns, :comm_prof_concerns, :overall_summ_comm_perf, :add_comm_on_perform, :mspe, :clinic_exp_comment '

      # query_params = "'%FoM%', '%JCON%', '%TRAN%', '%PREC 724%', '%SCHI%', '%CPX 702%', '%FAMP 705SD%', '%GMED 705AB%', " +
      #                "'%IMEDMINF 705B%', '%MULT 705A%', '%MULT 705C%', '%MULT 705D%', '%MULT 705TI%', '%709Z%'"

    mspe_data = []
    if permission_group_title == "Med23"
      Med23Mspe.all.each do |mspe|
         mspe = mspe.user.competencies.where(WHERE_QUERY, '%FoM%', '%JCON%', '%TRAN%', '%PREC 724%', '%SCHI%', '%CPX 702%', '%FAMP 705SD%', '%GMED 705AB%',
         '%IMEDMINF 705B%', '%MULT 705A%', '%MULT 705C%', '%MULT 705D%', '%MULT 705TI%', '%709Z%').select(:id, :student_uid, :user_id, :email,
           :course_id, :course_name, :final_grade, :start_date, :end_date, :submit_date, :evaluator, :prof_concerns, :mspe,
         ).order(:user_id, :start_date)
         mspe_data.push mspe
      end
    elsif permission_group_title == "Med24"
      Med24Mspe.all.each do |mspe|
         mspe = mspe.user.competencies.where(WHERE_QUERY2, '%FoM%', '%TRAN%', '%PREC 724%', '%SCHI%', '%CPX 702%', '%709Z%').select(:id, :student_uid, :user_id, :email,
           :course_id, :course_name, :final_grade, :start_date, :end_date, :submit_date, :evaluator, :prof_concerns, :mspe,
         ).order(:user_id, :start_date)
         mspe_data.push mspe
      end
    elsif permission_group_title >= "Med26"
      mspe_yr = permission_group_title.from(3)
      Med26Mspe.all.each do |mspe|
         mspe = mspe.user.new_competencies.where(WHERE_QUERY2, '%FoM%', '%TRAN%', '%PREC 724%', '%SCHI%', '%CPX 702%', '%709Z%').select(:id, :student_uid, :user_id, :email,
           :course_id, :course_name, :final_grade, :start_date, :end_date, :submit_date, :evaluator, :prof_concerns, :mspe,
         ).order(:user_id, :start_date)
         mspe_data.push mspe
      end
    end
    file_name = create_tab_delimited_file(permission_group_title, 'All', mspe_data)
    total_count = mspe_data.count
    mspe_data = []
    mspe_data.push "No of Student Selected: #{total_count.to_s}"
    return mspe_data, file_name

  end

  def hf_cohorts_comp_graph(comp_class_means)
    selected_categories = comp_class_means.first.last.keys
    height = 600
    title =  'Competency By Cohort(s) Graph' #+ '<br ><b>' + '(n = #{tot_count})' + '</b>'

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: title)
      #f.subtitle(text: '<br /><h4>Student: <b>' + student_name + '</h4></b>')
      f.xAxis(categories: selected_categories,
        labels: {
              style:  {
                          fontWeight: 'bold',
                          color: '#000000'
                      }
                }
      )

      comp_class_means.keys.each do |key|
          f.series(type: 'column', name: key, yAxis: 0, data: comp_class_means["#{key}"].values)
      end

      # ['#FA6735', '#3F0E82', '#1DA877', '#EF4E49']
      # f.colors(['#4572A7',
      #           '#AA4643',
      #           '#89A54E',
      #           '#80699B',
      #           '#3D96AE',
      #           '#DB843D',
      #           '#92A8CD',
      #           '#A47D7C',
      #           '#B5CA92'
      #           ])

      f.yAxis [
         { min: 0, max: 100,
           tickInterval: 25,
           title: {text: '<b>Competency (%) </b>', margin: 20}
         }
      ]
      f.plot_options(
        pie: {
            dataLabels: {
                enabled: true,
                crop: false,
                format: '<b>{point.name}</b>:<br>{point.percentage:.1f} %<br>value: {point.y}'
            }
        },
        column: {
            dataLabels: {
                enabled: true,
                crop: false,
                overflow: 'none'
            }
        },
        series: {
          cursor: 'pointer'
        }
      )
      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0)
      #f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({
                defaultSeriesType: 'column',
                width: 1800, height: height,
                plotBackgroundImage: ''
              })
    end

    return chart

  end

  def hf_highlight_mspe(text)
    text_marked = ""
    NEW_EPA_CODES.each do |epa_code|
      keywords = NEW_EPA_KEYWORDS[epa_code]
      epa_color = NEW_EPA_COLORS[epa_code]

      text = text.gsub(/\b(#{keywords.join("|")})\b/i,
                '<span style="color:' + "#{epa_color}" + '">' + "#{epa_code}: " + '<b>\1' +  '</span></b>').html_safe

    end

    return text

  end

  def hf_read_famp_core_data(course_codes)
    file_name = "#{Rails.root}/config/Med27_FAMP_CORE_Input_Data.txt"
    new_comp_array = []
    CSV.foreach(file_name, headers: true, col_sep: "\t") do |row|
      new_competency = NewCompetency.where("email=? and (course_name like ? or course_name like ?)", row["email"], "%#{course_codes.first} 730%", "%#{course_codes.second} 730%")
      if !new_competency.empty?
        new_comp_array.push new_competency
      end
    end
    return new_comp_array
  end


end
