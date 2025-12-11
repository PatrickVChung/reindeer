class UmeAssessPlan < ApplicationRecord

  def self.update_ume_assess_plans(assess_type, year, result_str)
    if assess_type == 'CPX'
      all_plans = UmeAssessPlan.where("year = ? and assessment_description like ?", year, "%#{assess_type}%")
    elsif assess_type == "Core"
      all_plans = UmeAssessPlan.where("year = ? and assessment_description like ?", year, "Core Clinical%")
    elsif assess_type == "Clinical"
      all_plans = UmeAssessPlan.where("year = ? and assessment_description like ?", year, "Clinical%")
    elsif assess_type == 'TRAN704'
      all_plans = UmeAssessPlan.where("year = ? and assessment_description like ?", year, "Transition%")
    elsif assess_type == 'Preceptor'
      all_plans = UmeAssessPlan.where("year = ? and assessment_description like ?", year, "Preceptorship%")
    elsif assess_type == "Narrative"
      all_plans = UmeAssessPlan.where("year = ? and assessment_description like ?", year, "Narrative Medicine%")
    elsif assess_type == "Scholarly"
      all_plans = UmeAssessPlan.where("year = ? and assessment_description like ?", year, "Scholarly%")
    elsif assess_type == "Step1Exam"
      all_plans = UmeAssessPlan.where("year = ? and assessment_description like ?", year, "USMLE Step 1 Exam%")
    elsif assess_type == "Step2CK"
      all_plans = UmeAssessPlan.where("year = ? and assessment_description like ?", year, "USMLE Step 2 CK%")      
    end

    target_result_str = result_str.split(";").first.split(": ").second
    all_plans.each do |plan|
      if target_result_str.gsub("%", "").to_i >= plan.target[0..2].gsub("%", "").to_i
        UmeAssessPlan.where(year: year, assessment_description: plan.assessment_description).update(target_met: true, target_results: result_str)
      else
        UmeAssessPlan.where(year: year, assessment_description: plan.assessment_description).update(target_met: false, target_results: result_str)
      end
    end
    return result_str
  end

  def self.check_cpx_remediation(result_set, total_count, pass_count)
    failed_students = result_set.select{|n| n if !JSON.parse(n.final_grade)["Grade"].include? "Pass"}
    fail_count = failed_students.count
    failed_students.each do |student|
      if !Competency.find_by(user_id: student.user_id, course_id: "1058").nil?   #checking cpx 702R
        fail_count -= 1
        pass_count += 1
      end
    end
    return total_count, pass_count, fail_count
  end

  def self.compute_stats(assess_type, result_set, start_date, end_date)
    total_count = result_set.count
    if assess_type == 'Preceptor'
     pass_count = result_set.select{|n| n if n.grade == "Pass"}.count
    else
     pass_count = result_set.select{|n| n if JSON.parse(n.final_grade)["Grade"].include? "Pass"}.count
   end
    fail_count = total_count - pass_count
    pass_percent = (pass_count.to_f/total_count.to_f * 100).round
    fail_percent = (fail_count.to_f/total_count.to_f * 100).round
    if assess_type == "CPX"
      total_count, pass_count, fail_count = check_cpx_remediation(result_set, total_count, pass_count)
      pass_percent = (pass_count.to_f/total_count.to_f * 100).round
      fail_percent = (fail_count.to_f/total_count.to_f * 100).round
    end
    result_str = "Pass: #{pass_percent}%; No Pass: #{fail_percent}%; Total Records: #{total_count}; Start Date: #{start_date}; End Date: #{end_date}"
    return result_str
  end

  def self.update_clinical_exp(year, start_date, end_date, cohort)
    new_competencies = NewCompetency.where("start_date >= ? and end_date <= ?", start_date, end_date)
    result_str = compute_stats("Clinical", new_competencies, start_date, end_date)
    result_str = update_ume_assess_plans("Clinical", year, result_str)
    new_competencies = nil
    return result_str
  end

  def self.update_core_clinical_exp(year, start_date, end_date, cohort)
    new_competencies = NewCompetency.where("start_date >= ? and end_date <= ? and course_name like ?", start_date, end_date, "%Core%")
    result_str = compute_stats("Core", new_competencies, start_date, end_date)
    # UmeAssessPlan.where(year: "2024-2025", assessment_description: "Core Clinical Experiences").update(target_results: result_str)
    result_str = update_ume_assess_plans("Core", year, result_str)
    new_competencies = nil
    return result_str
  end

  def self.update_cpx(year, start_date, end_date)
    if year == "2024-2025"
      competencies = Competency.where("start_date >= ? and end_date <= ? and course_name like ?", start_date, end_date, "%CPX 702%")
      result_str = compute_stats("CPX", competencies, start_date, end_date)
    else
      new_competencies = NewCompetency.where("start_date >= ? and end_date <= ? and course_name like ?", start_date, end_date, "%CPX 702%")
      result_str = compute_stats("CPX", new_competencies, start_date, end_date)
    end
    # UmeAssessPlan.where(year: year, assessment_description: "Clinical Performance Exam (CPX)").update(target_results: result_str)
    # UmeAssessPlan.where(year: year, assessment_description: "Clinical Performance Evaluation (CPX)").update(target_results: result_str)
    result_str = update_ume_assess_plans("CPX", year, result_str)
    competencies = nil
    new_competencies = nil
    return result_str
  end

  def self.update_trans_704(year, start_date, end_date)
    if year == "2024-2025"
      competencies = Competency.where("start_date >= ? and end_date <= ? and course_name like ?", start_date, end_date, "%TRAN 704%")
      result_str = compute_stats("TRAN704", competencies, start_date, end_date)
    else
      new_competencies = NewCompetency.where("start_date >= ? and end_date <= ? and course_name like ?", start_date, end_date, "%TRAN 704%")
      result_str = compute_stats("TRAN704", new_competencies, start_date, end_date)
    end
    # UmeAssessPlan.where(year: year, assessment_description: "Transition to Residency").update(target_results: result_str)
    # UmeAssessPlan.where(year: year, assessment_description: "Transition to Residency Course Simulation").update(target_results: result_str)
    result_str = update_ume_assess_plans("TRAN704", year, result_str)
    competencies = nil
    new_competencies = nil
    return result_str
  end

  def self.update_preceptor(year, start_date, end_date)
    preceptors = PreceptorAssess.where("submit_date >= ? and submit_date <= ?", start_date, end_date)
    result_str = compute_stats("Preceptor", preceptors, start_date, end_date)
    result_str = update_ume_assess_plans("Preceptor", year, result_str)
    preceptors = nil
    return result_str
  end

  def self.update_narrative(year, start_date, end_date)
    if year == "2024-2025"
      competencies = Competency.where("start_date >= ? and end_date <= ? and course_name like ?", start_date, end_date, "%SCHI 701%")
      result_str = compute_stats("Narrative", competencies, start_date, end_date)
    else
      new_competencies = NewCompetency.where("start_date >= ? and end_date <= ? and course_name like ?", start_date, end_date, "%SCHI 701%")
      result_str = compute_stats("Narrative", new_competencies, start_date, end_date)
    end
    # UmeAssessPlan.where(year: year, assessment_description: "Clinical Performance Exam (CPX)").update(target_results: result_str)
    # UmeAssessPlan.where(year: year, assessment_description: "Clinical Performance Evaluation (CPX)").update(target_results: result_str)
    result_str = update_ume_assess_plans("Scholarly", year, result_str)
    competencies = nil
    new_competencies = nil
    return result_str
  end

  def self.update_scholarly_project(year, start_date, end_date)
    if year == "2024-2025"
      competencies = Competency.where("course_name like ?", "%SCHI 703%").joins(:user).where(permission_group_id: 18)  #Med24
      result_str = compute_stats("Narrative", competencies, start_date, end_date)
      result_str += "; Med24"
    else
      new_competencies = NewCompetency.where("start_date >= ? and end_date <= ? and course_name like ?", start_date, end_date, "%SCHI 701%")
      result_str = compute_stats("Narrative", new_competencies, start_date, end_date)
    end
    # UmeAssessPlan.where(year: year, assessment_description: "Clinical Performance Exam (CPX)").update(target_results: result_str)
    # UmeAssessPlan.where(year: year, assessment_description: "Clinical Performance Evaluation (CPX)").update(target_results: result_str)
    result_str = update_ume_assess_plans("Scholarly", year, result_str)
    competencies = nil
    new_competencies = nil
    return result_str
  end

  def self.compute_stats2(assess_type, result_set, start_date, end_date)
    total_count = result_set.count
    if assess_type == 'Step1Exam'
      pass_count = result_set.select{|n| n if n.pass_fail == "P"}.count
      fail_count = total_count - pass_count
      pass_percent = (pass_count.to_f/total_count.to_f * 100).round
      fail_percent = (fail_count.to_f/total_count.to_f * 100).round
    end
    result_str = "Pass: #{pass_percent}%; No Pass: #{fail_percent}%; Total Records: #{total_count}; Start Date: #{start_date}; End Date: #{end_date}"
    return result_str
  end

  def self.update_step1_exam(year, start_date, end_date)
    competencies = UsmleExam.where("exam_date >= ? and exam_date <= ? and exam_type='Step 1 Exam' and no_attempts=1", "2024-07-01", "2025-06-20")
    result_str = compute_stats2("Step1Exam", competencies, start_date, end_date)
    result_str = update_ume_assess_plans("Step1Exam", year, result_str)
    competencies = nil
    new_competencies = nil
    return result_str
  end

  def self.update_step2_ck(year, start_date, end_date)
    competencies = UsmleExam.where("exam_date >= ? and exam_date <= ? and exam_type='Step 2 CK' and no_attempts=1", "2024-07-01", "2025-06-20")
    result_str = compute_stats2("Step1Exam", competencies, start_date, end_date)
    result_str = update_ume_assess_plans("Step2CK", year, result_str)
    competencies = nil
    new_competencies = nil
    return result_str
  end

end
