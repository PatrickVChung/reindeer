module MedhubApisHelper


  def get_data (call_path_str, req_str)
      clientID="10006"
      institution="ohsu"   #"ohsu-test"
      privateKey="e01yxdq5vrrx"
      # Sample call path
      callPath = call_path_str   #users/studentInfo"

      # Get UNIX timestamp
      timeNow = (Time.now).to_i.to_s
      #param1 = ARGV[0].to_i
      # Create request
      request = req_str   # {"userID":param1}
      request = request.to_json

      # Generate verification string
      temp_str = clientID + "|" + timeNow + "|" + privateKey + "|"
      unless request.empty?
          temp_str += "#{request}"
      end
      # verifyStr = Digest::SHA256.new << temp_str
      # verifyStr = "#{verifyStr}"
      #puts "**********************************"
      #puts temp_str
      #puts "*********************************"
      #binding.pry
      verifyStr = Digest::SHA256.hexdigest(temp_str)
      # Construct data to send
      post_data = {
       "clientID" => clientID,
       "ts" => timeNow,
       "verify" => verifyStr,
       "type" => "json",
      }

      unless request.empty?
          post_data["request"] = request
      end
      post_json = post_data
      # Request URL
      url="https://" + institution + ".medhub.com/functions/api/" + callPath
      #puts post_json
      retries = 10
      response = ""
      begin
        Timeout::timeout(10) do
           response = HTTParty.post(url,
                             body: post_json,
                             )
        end
      rescue Exception=> e
          puts "========================================="
          puts "==== Error Caught: #{e}"
          puts "==== Retries: #{retries}"
          puts "========================================="
          if retries > 0
              retries -= 1
              sleep 2
              retry
          end
      end
      return response
  end

  def is_numeric?(obj)
     obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  def get_comments(various_comments, question, comments)
    if @debug == 'Y'
      MedhubLog.info "*** inside get_comments:  question --> " + question
      MedhubLog.info "==========================================================================="
      MedhubLog.info "question --> #{question}"
      MedhubLog.info "comments --> #{comments}"
      MedhubLog.info "============================================================================"
    end
      # if question == "Comments"
      #     return
      # end
      #
      if question.include? "any areas of this"
             various_comments["prof_concerns"] = comments
      elsif question.include? "noted professionalism"
             various_comments["comm_prof_concerns"] = comments
             if comments.include? "Multiple providers were concerned"
                 MedhubLog.info  "========================================================"
                 MedhubLog.info  " CommProfConcern ==> " + comments
                 MedhubLog.info  "========================================================"
                 #binding.pry
             end
      elsif question.include? "MSPE (Dean's Letter)"
             various_comments["mspe"] = comments
      elsif question.include? "Narrative Feedback"
              various_comments["feedback"]  = comments
      elsif question.include? "overall student performance"
             various_comments["overall_summ_comm_perf"] = comments
             various_comments["mspe"] = comments
      elsif question.include? "Additional comments for student"
             various_comments["add_comm_for_student"] = comments
      elsif question.include? "Comment on student"  # for PREC 724 Precetorship comments
              various_comments["mspe"] = comments
      elsif question.include? "Optional Clinical Experience"
              various_comments["clinic_exp_comment"] = comments
      else
          MedhubLog.info  "============================================================="
          MedhubLog.info  "New type of comment ===> " + question
          MedhubLog.info  "comments ==> " + comments
          MedhubLog.info  "============================================================="
          #binding.pry
      end

      #return various_comments

  end

  def question_text(question_hash, questionID, answer_optionID)
      #ques_desc = @question_hash.select {|item| item["questionID"] == questionID}[0]["question_text"]
      question_hash.each do |question_hash|
        if question_hash["questionID"] == questionID.to_s
          return question_hash["question_text"]
        end
      end

      return ""
      #return ques_desc
  end

  def answer_value(question_hash, questionID, answer_optionID)
     pass_np = question_hash.select{|key, val| key if key["questionID"] == questionID}.
               first["options"].select{|key, val| key if key["optionID"] == answer_optionID}.first["option_title"]

     return pass_np
  end

  def process_competency(competency, question_hash, questionID, q_text, answer_optionID)

      if answer_optionID.kind_of? (Array)
          return
      end
      question = question_hash.select{|q| q["questionID"] == questionID}
      a_value = question.first["options"].select{|o| o["optionID"] == answer_optionID}.first["option_value"]
      if a_value.empty?
          return
      end
      temp_str = q_text.split(": ")
      code = temp_str.first
      desc = temp_str.second
      if code == "Student"
          return
      end
      if code == "PPD"
          code = "PPPD"
      end
      code = code.gsub(" ", "").downcase

      if @debug == "Y"
          MedhubLog.info  "=========================================="
          MedhubLog.info  "a_value --> #{a_value} = desc --> #{desc}"
          MedhubLog.info  "=========================================="
      end

      if desc.to_s != '' and a_value.to_s != ''
          if !['are0', 'select0', 'were0'].include? code  # exclude those codes in the array
            competency[code] = a_value.to_s #+ "~" + desc
          end
          # @comments[code] = "None"
          # @comp_code = code
      end
  end

  def process_question_value(grade, competency, various_comments, question_hash, answers_array)
    answers_array.each do |q_obj|
      ques_desc = ""
      ans_value = ""
      questionID = q_obj["questionID"]
      answer_optionID = q_obj["answer_optionID"]
      answer_text = q_obj["answer_text"]
      q_text = question_text(question_hash, questionID, answer_optionID)

      if @debug == "Y"
        MedhubLog.info "#{questionID.to_s.rjust(20)} = #{q_text}"
        MedhubLog.info "#{answer_optionID.to_s.rjust(20)} = #{answer_text}"
      end

      if answer_optionID.to_s != ""   ## competency data
        process_competency(competency, question_hash, questionID, q_text, answer_optionID)
      end

      if @debug == "Y"
          MedhubLog.info "#{questionID.to_s.rjust(20)} = #{q_text}"
      end

      MedhubLog.info "q_text ==> #{q_text}"

      if q_text[0..8] == "Component"
        ## ans_value will contain 'Pass' or 'No Pass'
        ans_value = answer_value(question_hash, questionID, answer_optionID)
        grade.store(q_text, answer_text)
      end
      numeric_grade = ""
      if answer_text != ""
          #answer_optionID = "ANSWER"
          ans_value = q_obj["answer_text"]

          if is_numeric? ans_value[0..3]
              if ans_value.include? ":"
                 ans_value = decode_concerns(ans_value)
              else
                  numeric_grade = ans_value
                  MedhubLog.info  "================ numeric_grade: " + @numeric_grade + "======================"
                  grade =  "/" + numeric_grade.to_s
                  grade = grade.gsub("//", "/")
                  grade.store("Grade", grade)
              end
          end
          if q_text.include? "Total Equated Percent Correct Score"
              MedhubLog.info  "###### Total Equated Percent Correct Score: " + ans_value
              numeric_grade = ans_value
              grade =  "/" + numeric_grade.to_s
              grade = grade.gsub("//", "/")
              grade.store("Grade", grade)
          elsif q_text != "Comments"
              get_comments(various_comments, q_text, ans_value)
          else
             #@comments[@comp_code] = ans_value #get_competency_comments(q_text, ans_value)
          end
      elsif answer_optionID.to_s != "" and !answer_optionID.kind_of?(Array)
        ans_value = answer_value(question_hash, questionID, answer_optionID)
      else
        ans_value = ""
      end

    end #answers_array
    final_grade = {}
    final_grade.store("Grade", grade)
    return final_grade, competency, various_comments

  end

  def load_prof_concerns(question_hash, in_str)
      prof_concerns_hash = {}
      concern_options = question_hash.select{|item| item["optionset_title"] == "Multi: Professionalism Areas of Concern"}
      concern_options.each do |key|
          options = key["options"]
          options.each do |k|
            optionID = k["optionID"]
            optionTitle = k["option_title"]
            prof_concerns_hash[optionID] = optionTitle
          end
      end
      return prof_concerns_hash
  end

  def load_evaluationID(evaluationID)
      question_hash = []
      req_str = {"evaluationID":evaluationID}
      call_path_str = "evals/questions"

      response = get_data(call_path_str, req_str)
      question_hash = JSON.parse(response.body)

      if @debug == "Y"
          MedhubLog.info "***************@question_hash ************************************"
          MedhubLog.info "***** evaluationID: #{evaluationID} *******************************"
          question_hash.each do |key, value|
              key.each do |k, v|
                  MedhubLog.info "#{k.rjust(20)} : #{v}"
              end
          end
          MedhubLog.info "***************************************************"
      end

      prof_concerns_hash = load_prof_concerns(question_hash, "any areas of student's professionalism")

      return question_hash, prof_concerns_hash

  end

  def update_or_insert_new_competencies(row_hash, full_name)

      #NewCompetency.where(medhub_id: row_hash["medhub_id"], course_id: row_hash["course_id"]).first_or_create.update(row_hash)
      if NewCompetency.exists?(user_id: row_hash["user_id"], medhub_id: row_hash["medhub_id"], course_id: row_hash["course_id"])
        NewCompetency.where(user_id: row_hash["user_id"], medhub_id: row_hash["medhub_id"], course_id: row_hash["course_id"]).first_or_create.update(row_hash)
        MedhubLog.info "======================================================================"
        MedhubLog.info "#### Updated:  #{full_name} ###########"
        MedhubLog.info "----------------------------------------------------------------------"
      else
        NewCompetency.where(user_id: row_hash["user_id"], medhub_id: row_hash["medhub_id"], course_id: row_hash["course_id"]).first_or_create(row_hash)
        MedhubLog.info "======================================================================"
        MedhubLog.info "#### Inserted:  #{full_name} ###########"
        MedhubLog.info "----------------------------------------------------------------------"
      end

      # @prof_concerns_hash = {}
      # @various_comments = {}
      # @competency = {}
      # @comments = {}
      # @completeDate = ""

  end

  def get_evals_responses(userID, grade, courseID, email, medhubID, eval_start_date)
      userID = userID.to_i
      courseID = courseID.to_i

      req_str = {"startDate": eval_start_date,
                 "types":[5,18],
                 "evaluatees":[userID],
                 "courses":[courseID]
                }
      call_path_str = "evals/responses"
      response = get_data(call_path_str, req_str)

      response_hash = JSON.parse(response.body)
      reponse_hash = response_hash.select{|r| r if r["response_title"].include? "(V-17.1) (FINAL)"}

      # MedhubLog.info "******************* Eval Response Hash ****************************"
      # response_hash.first.each do |key, value|
      #   MedhubLog.info "#{key.rjust(20)} ==> #{value}"
      #   if key == 'answers'
      #     MedhubLog.info "************* ANSWERS *************************"
      #     value.first.each do |key, value|
      #       MedhubLog.info "#{key.rjust(20)} ==> #{value}"
      #     end
      #     MedhubLog.info "***********************************************"
      #   end
      # end

      row_hash = {}
      response_hash.each do |data|
        if data["response_title"].include? "(V-17.1) (FINAL)" #or key["response_title"].include? "MSPE"
           user = User.find_by(email: email)
           medhub_course = MedhubCourse.find_by(course_id: courseID)
           course_name = "[#{medhub_course.course_code}] #{medhub_course.course_name}"

           row_hash["user_id"] = user.id
           row_hash["permission_group_id"] = user.permission_group_id
           row_hash["student_uid"] = user.sid
           row_hash["email"]       = email
           row_hash["medhub_id"]   = medhubID
           row_hash["course_id"]   = courseID.to_s
           row_hash["course_name"] = course_name
           row_hash["submit_date"] = data["completion_date"]
           row_hash["start_date"]  = data["rotation_start_date"]
           row_hash["end_date"]    = data["rotation_end_date"]
           row_hash["evaluator"]   = data["evaluator_name"]

           # row_hash["prof_concerns"] =
           # t.text "comm_prof_concerns"
           # t.text "overall_summ_comm_perf"
           # t.text "add_comm_on_perform"
           # t.text "mspe"
           # t.text "clinic_exp_comment"
           # t.text "feedback"

           final_competency = {}
           various_comments = {}
           competency = {}
           question_hash, prof_concerns_hash = load_evaluationID(data["evaluationID"])   # load question

           MedhubLog.info "---> #{data["evaluationID"]} --> #{data["response_title"]}"

           final_grade, final_competency, various_comments = process_question_value(grade, competency, various_comments, question_hash, data["answers"])

           row_hash["final_grade"] = final_grade.to_json
           row_hash = row_hash.merge(final_competency).merge(various_comments)
           update_or_insert_new_competencies(row_hash, user.full_name)
          end

      end
     end
  end

  def get_users (grade, userID, start_date, end_date, courseID, level_year, eval_start_date)
    req_str = {"userID":userID}
    call_path_str = "users/studentInfo"
    response2 = get_data(call_path_str, req_str)
    response2_hash = JSON.parse(response2.body)
    matr_start_date  = response2_hash["start_date"]

    if response2_hash["level"].to_i == level_year.to_i and grade.to_s != ""
        email = response2_hash["email"].to_s
        studentID = response2_hash["studentID"]
        studentName = response2_hash["name_last"].to_s + ", " + response2_hash["name_first"].to_s
        MedhubLog.info "processing:  #{studentName}  #{email}  #{grade} matr_start_date: #{matr_start_date} --> level: #{response2_hash["level"]}"
        medhubID = userID.to_s
        if NewCompetency.exists?(medhub_id: medhubID, course_id: courseID)
          MedhubLog.info (" ***** Found in NewCompetency, Skipping Update! ****")
        else
          get_evals_responses(userID, grade, courseID, email, medhubID, eval_start_date)   ## get comments and competency information
        end
     end

  end

  def schedules_enrollment(start_date, end_date, periodID, courseID, level_year, eval_start_date)
        call_path_str = "schedules/enrollment"
        req_str = {"periodID":periodID, "courseID":courseID}
        response = get_data(call_path_str, req_str)
        if @debug == "Y"
          MedhubLog.info  "======================================"
          MedhubLog.info  response.body
          MedhubLog.info  "======================================"
        end
        data_hash = JSON.parse(response.body)
        data_hash = data_hash.uniq

        # MedhubLog.info " ******Schedules Enrollment data hash ************"
        # MedhubLog.info data_hash.inspect

        #byebug
        if !data_hash.empty?
           data_hash.each do |data|
             if data["grade"].to_s != ""
               get_users(data["grade"], data["userID"], start_date, end_date, courseID, level_year, eval_start_date)

             end
           end
        end
  end

  def get_schedules_periods(courseID, rotationStartYr, rotationEndYr, level_year, eval_start_date)
     call_path_str = "schedules/periods"
     for rotationsetID in rotationStartYr..rotationEndYr #10..18  #21..22
        req_str = {"courseID":courseID, "rotationsetID":rotationsetID}
        response = get_data(call_path_str, req_str)
        data_hash = JSON.parse(response.body)
        data_hash = data_hash.uniq
        #
        # MedhubLog.info "--------------schedules/periods-----------------------------"
        # MedhubLog.info  "data_hash: "
        # MedhubLog.info  data_hash.inspect
        # MedhubLog.info  "-------------------------------------------"

        if !data_hash.empty?
            no_enrollment = true
            data_hash.each do |data|
              if Date.parse(data["start_date"]).strftime("%F") < Date.today.strftime("%F")
                  start_date = data["start_date"]
                  end_date   = data["end_date"]
                  periodID   = data["periodID"]

                  MedhubLog.info "processing startDate: #{start_date}   endDate: #{end_date}   periodID: #{periodID}"
                  schedules_enrollment(start_date, end_date, periodID, courseID, level_year, eval_start_date)
              end
            end

        end
      end
  end

  def hf_access_medhub(course_ids, rotationStartYr, rotationEndYr, level_year, eval_start_date, debug)
    @debug = debug
    init_global_vars
    course_ids.each do |course_id|
      MedhubLog.info("Processing #{course_id}  --> rotation Year from: #{rotationStartYr} to #{rotationEndYr}; EvalStartDate: #{eval_start_date}")
      get_schedules_periods(course_id, rotationStartYr, rotationEndYr, level_year, eval_start_date)
    end

  end

def init_global_vars

   @no_of_rec_selected = 0
   @no_of_rec_rejected = 0
   @no_of_rec_updated  = 0
   @no_of_rec_inserted = 0
end

def hf_eval_start_date
  return Date.today.months_ago(6).strftime("%Y/%m/%d")
end
#----------------------------------------------------------------------------------------------------------

def get_users_enroll (grade, userID, start_date, end_date, courseID, level_year, eval_start_date)
  req_str = {"userID":userID}
  call_path_str = "users/studentInfo"
  response2 = get_data(call_path_str, req_str)
  response2_hash = JSON.parse(response2.body)
  matr_start_date  = response2_hash["start_date"]

  if response2_hash["level"].to_i >= level_year.to_i #and grade.to_s != ""
      email = response2_hash["email"].to_s
      studentID = response2_hash["studentID"]
      studentName = response2_hash["name_last"].to_s + ", " + response2_hash["name_first"].to_s
      MedhubLog.info ("processing:  #{studentName}  #{email}  #{grade} matr_start_date: #{matr_start_date} --> level: #{response2_hash["level"]}")
      # medhubID = userID.to_s
      # if NewCompetency.exists?(medhub_id: medhubID, course_id: courseID)
      #   MedhubLog.info (" ***** Found in NewCompetency, Skipping Update! ****")
      # else
      #   get_evals_responses(userID, grade, courseID, email, medhubID, eval_start_date)   ## get comments and competency information
      # end
   end

end

def hf_access_enrollment(courseID, rotation_start_yr, rotation_end_yr)
  enroll_hash = {}
  MedhubLog.info ("processing courseID: #{courseID} --> RotationStartYear: #{rotation_start_yr} to endYear: #{rotation_end_yr}")
  call_path_str = "schedules/periods"
  for rotationsetID in rotation_start_yr..rotation_end_yr #10..18  #21..22
     req_str = {"courseID":courseID, "rotationsetID":rotationsetID}
     response = get_data(call_path_str, req_str)
     data_hash = JSON.parse(response.body)
     data_hash = data_hash.uniq

     MedhubLog.info ("*** Schedules/Periods *********")
     MedhubLog.info (data_hash.inspect)
     MedhubLog.info ("********************************")

     if !data_hash.empty? and !data_hash.first.include? "ErrorCode"
         data_hash.each do |data|
             start_date = data["start_date"]
             end_date   = data["end_date"]
             periodID   = data["periodID"]
             MedhubLog.info ("processing startDate: #{start_date}   endDate: #{end_date}   periodID: #{periodID}")
             call_path_str = "schedules/enrollment"
             req_str = {"periodID":periodID, "courseID":courseID}
             enrollment_responses = get_data(call_path_str, req_str)
             enrollments = JSON.parse(enrollment_responses.body)
             enrollments = enrollments.uniq
             if !enrollments.empty?
               temp_array = []
                enrollments.each do |enroll|
                  MedhubLog.info ("----- enroll.inspect --------------------")
                  MedhubLog.info (enroll.inspect)
                  MedhubLog.info ("------------------------------------------")
                  temp_array.push enroll
                  level_year = 2
                  eval_start_date = "2025-04-01"
                  #get_users_enroll(data["grade"], data["userID"], start_date, end_date, courseID, level_year, eval_start_date)
                end
             end
             enroll_hash["#{start_date}!#{end_date}!#{periodID}"] = temp_array
            end
        elsif !data_hash.empty? and data_hash.first.include? "ErrorCode"
              enroll_hash["#{data_hash.first}!#{data_hash.second}"] = nil

         end
   end
   return enroll_hash
end
