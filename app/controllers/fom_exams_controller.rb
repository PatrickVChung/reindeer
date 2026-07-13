class FomExamsController < ApplicationController
  layout 'full_width_csl'
  protect_from_forgery prepend: true, with: :exception
  before_action :authenticate_user!, :get_tso_emails, :set_resources

  include FomExamsHelper
  include ArtifactsHelper
  include CompetenciesHelper

  # def index
  #   # user = User.find_by(uuid: params[:uuid])
  #   # @artifacts = Artifact.where(user_id: user.id)
  #   @artifacts = User.find_by(uuid: params[:uuid]).artifacts
  #
  # end

  def process_fom
    @artifacts = User.find_by(uuid: params[:uuid]).artifacts

  end

  def list_all_blocks
    last_permission_group_id = PermissionGroup.last.id
    @list_all_blocks = FomLabel.where("permission_group_id >= ?", last_permission_group_id-2).pluck(:permission_group_id, :course_code).sort
    respond_to do |format|
      format.html
    end
  end

  def export_block
    if params[:permission_group_id].present? and params[:course_code].present?
      @export_block = hf_export_fom_block(params[:permission_group_id], params[:course_code])
      @fom_labels = FomLabel.where(permission_group_id: params[:permission_group_id].to_i, course_code: params[:course_code])
      #@export_block = FomExam.includes(:user_only_fetch_email).where(permission_group_id: params[:permssion_group_id], course_code: params[:course_code])
      @fom_headers = JSON.parse(@fom_labels.first.labels)
      @file_name = "fom_exam_#{params[:course_code]}.txt"
      create_file @export_block, @file_name
      #send_data @export_block.to_csv,  filename: 'export_block.csv', disposition: 'download'
    end
    respond_to do |format|
      format.html {render  layout: 'full_width_extra_large'}
    end
  end

  def download_file
      if params[:file_name].present?
         private_download params[:file_name]
      end
  end

  def process_csv
    # @artifacts.first.documents.first.download --> works
    if !hf_check_label_file(params[:attach_id])
      @log_results = FomExam.process_file(params[:attach_id])
    end
  end

  def process_mid_block
    @log_results = FomExam.process_mid_block(params[:attach_id], params[:artifact_content])
  end

  def send_alerts

    if params[:uniq_cohort].present?
      @tso_ids = User.where(subscribed: true, coaching_type: ['dean', 'admin']).order(:id).pluck(:id)
      # course_code = FomExam.where(permission_group_id: params[:uniq_cohort]).select(:course_code).order(:course_code).distinct.pluck(:course_code).last
      # @cohort_ids = FomExam.where(permission_group_id: params[:uniq_cohort], course_code: course_code).select(:id, :user_id).pluck(:user_id)
      @cohort_ids = User.where(permission_group_id: params[:uniq_cohort], subscribed: true).order(:full_name).pluck(:id)
      @user_ids = @tso_ids
    elsif params[:body_message].present? # from ajax  call here\
        uniq_cohort = params[:selected_cohort]
        @dean_users = User.where(subscribed: true, coaching_type: ['dean', 'admin']).order(:id)
        @from = params[:from]
        @subject = params[:subject]
        body_message = params[:body_message]
        total_count = 0
        total_count += @dean_users.count
        @dean_users.each do |user|
            hello = "Hello " + user.full_name.split(", ").last + ",<br /><br />"
            @body_message = hello + body_message
            FomExamMailer.send_alert(@from, user.email, @subject, @body_message.html_safe).deliver_later
        end
        if (params[:checkAll].present? and params[:checkAll] == "checkAll")
          @users = User.where(permission_group_id: uniq_cohort, subscribed: true).order(:full_name)
          @users.each do |user|
              hello = "Hello " + user.full_name.split(", ").last + ",<br /><br />"
              @body_message = hello + body_message
              FomExamMailer.send_alert(@from, user.email, @subject, @body_message.html_safe).deliver_later

          end
          total_count += @users.count
        end

        hello = "Hello " + @tso_emails.first["TSO1"]["name"].split(", ").last + ",<br /><br />"
        @body_message = hello + body_message
        FomExamMailer.send_alert(@from, @tso_emails.first["TSO1"]["email"], @subject, @body_message.html_safe).deliver_later

        hello = "Hello " + @tso_emails.second["TSO2"]["name"].split(", ").last + ",<br /><br />"
        @body_message = hello + body_message
        FomExamMailer.send_alert(@from, @tso_emails.second["TSO2"]["email"], @subject, @body_message.html_safe).deliver_later

        total_count += 2

        flash.now[:notice] = "You have sent out #{total_count.to_s} emails!"

    end

    respond_to do |format|
      format.html # Normal page fallback
      format.turbo_stream do
        render turbo_stream: [
          # 1. Dynamically replace the flash message area at the top of the page
          turbo_stream.update("flash-container", partial: "layouts/flashes"),

          # 2. Dynamically replace the lower results area with the updated list
          turbo_stream.update("alerts_results", inline: <<~ERB
            <div class="d-flex justify-content-center w-100">
              <%= render "fom_exams/send_alerts_list", user_ids: @user_ids, cohort_ids: @cohort_ids %>
            </div>
          ERB
          )
        ]
      end
    end

  end

  def unsubscribe
    if User.find_by(uuid: params[:id]).update(subscribed: false)
      flash[:alert] = 'Your FoM Subscription was Cancelled!'
      redirect_to root_url
    else
      flash[:alert] = 'There was a problem!'
      render :unsubscribe
    end
    respond_to do |format|
      format.html
    end

  end

  # def show
  #   display_fom
  # end

  def display_fom

    if params[:uuid].present?  and params[:course_code].present? #current_user.admin_or_higher?
      if params[:uuid] == current_user.uuid or current_user.coaching_type == 'dean' or
        current_user.coaching_type == 'coach' or current_user.coaching_type == 'admin'
       #permission_group_id  = 17 # cohort Med23
       aes_key = session[:aes_key]
       @course_code = AES.decrypt(params[:course_code], aes_key) #session[:course_code]  #params[:course_code]
       permission_group_id = AES.decrypt(params[:permission_group_id], aes_key).to_i ## from Search function, required for cohort jumpers.


       student  = User.find_by(uuid: params[:uuid])
       @cohort = PermissionGroup.find(permission_group_id).title.delete('()').split(" ").last.downcase
       if @cohort == 'med22'
         table_name_prefix = @cohort + "_"
          @comp_keys = FomExam.comp_keys
       elsif @cohort <= 'med21'
         table_name_prefix = 'med21'+ "_"
          @comp_keys = FomExam.comp_keys_med21
      elsif @cohort >=  'med30'
           tabole_name_prefix = ""
           @comp_keys = FomExam.comp_keys_new
       else
         table_name_prefix = ""
          @comp_keys = FomExam.comp_keys
       end

       @student_email = student.email
       @student_full_name = student.full_name
       @student_perm_group = student.permission_group_id
       @student_cohort_title = @cohort_titles[permission_group_id]
       #@coach_info = student.cohort.nil? ? "Not Assigned" : student.cohort.title
       @block_desc = hf_get_block_desc(@course_code)
       @student_uid = student.sid
       if ['dean', 'admin'].include? current_user.coaching_type
         block_enabled = true ## always visible
         @comp_exams, @comp_avg_exams,  @exam_headers = FomExam.exec_raw_sql(student.id, session[:attach_id], permission_group_id, @course_code, block_enabled, table_name_prefix)
         if permission_group_id >= 24 #Med20
           @comp1f_exam, @comp1f_avg_exam = FomExam.get_comp6(student.id, permission_group_id, @course_code, block_enabled, table_name_prefix)
           @comp_exams = [].push @comp_exams.first.merge @comp1f_exam
           @comp_avg_exams = [].push @comp_avg_exams.first.merge @comp1f_avg_exam
         end

       elsif current_user.coaching_type == 'student'
         block_enabled = FomLabel.find_by(course_code: @course_code, permission_group_id: permission_group_id).block_enabled
         if block_enabled
           @comp_exams, @comp_avg_exams,  @exam_headers = FomExam.exec_raw_sql(student.id, session[:attach_id], permission_group_id, @course_code, block_enabled, table_name_prefix)
           if permission_group_id >= 24 #Med20
             @comp1f_exam, @comp1f_avg_exam = FomExam.get_comp6(student.id, permission_group_id, @course_code, block_enabled, table_name_prefix)
             @comp_exams = [].push @comp_exams.first.merge @comp1f_exam
             @comp_avg_exams = [].push @comp_avg_exams.first.merge @comp1f_avg_exam
           end
         else
           @comp_exams = nil
         end
       end
       ## added permission_group_id from Search function to take care of cohort jumper
       if @comp_exams != nil

         @failed_comps = hf_scan_failed_score(@comp_exams)
         block_code = @course_code.split("-").second  #course_code format '1-FUND', '2-BLHD', etc
         @artifacts_student_fom, @no_official_docs, @shelf_artifacts = hf_get_fom_artifacts(@student_email, "FoM", block_code)

         @formative_feedbacks_orig = FormativeFeedback.where("user_id=? and block_code=? and csa_code not like ? ", student.id, block_code, "%Informatics%").order(:submit_date).map(&:attributes)
         @formative_feedbacks_qualtrics = @formative_feedbacks_orig.select{|feed| feed if feed["response_id"].start_with? 'R_'}.compact
         @formative_feedbacks = hf_collect_values(@formative_feedbacks_orig)

         #@informative_feedbacks = FormativeFeedback.where(user_id: student.id, block_code: block_code).map(&:attributes)
         @informatics_feedbacks = FormativeFeedback.where("user_id=? and block_code=? and csa_code like ?", student.id, block_code, "%Informatics%").map(&:attributes)

         #@simcap_feedbacks = FormativeFeedback.where("user_id=? and block_code=? and response_id like ?", student.id, block_code, "SimCap%")
         #@informatics_feedbacks = hf_collect_values(informatics_feedbacks)
       else
         @comp_keys =  '*** This Block is being disabled temporary or has not been created just yet!! ***'
       end

       ## don't display remediation data for now
       #@remeds = FomRemed.where(user_id: student.id)  #, block: block_code)
     else
       @comp_keys = ' **** You NOT AUTHORIZED to view this account! ***'
     end
    end

    respond_to do |format|
      format.html
    end

  end

 private

 def set_resources
   @permission_groups = PermissionGroup.last(3) # get last 3 rows
   cohorts = PermissionGroup.where("id <> 7 and title like ?", "%Med%").select(:id, :title).order(:id).map(&:attributes)
   @cohort_titles = hf_reformat_cohort_data(cohorts)

   #@crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31], Rails.application.secrets.secret_key_base)
 end

 def private_download in_file
    send_file  "#{Rails.root}/tmp/#{in_file}", type: 'text', disposition: 'download'
 end

 def get_tso_emails
   @tso_emails ||= YAML.load_file("config/sendAlertEmails.yml")

 end

 def create_file (in_data, in_file)
   file_name = "#{Rails.root}/tmp/#{in_file}"

   CSV.open(file_name,'wb', col_sep: "\t") do |csvfile|
     csvfile << in_data.first.keys.map{|c| c.titleize}
     in_data.each do |row|
       csvfile << row.values
     end
   end
 end


end
