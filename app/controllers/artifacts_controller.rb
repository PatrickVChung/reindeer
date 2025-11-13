class ArtifactsController < ApplicationController
  layout 'full_width_margins'
  before_action :authenticate_user!
  before_action :set_artifact, only: [:show, :edit, :update, :destroy, :move]

  include ArtifactsHelper
  include FomExamsHelper


  # GET /artifacts
  def index
    if !params[:uuid].nil?
      user = User.find_by(uuid: params[:uuid])
      if (hf_file_visible("Mock Step 1") == true)
        @artifacts = User.find_by(uuid: params[:uuid]).artifacts   #Artifact.where(user_id: user.id)
      else
          #@artifacts = Artifact.where("user_id = ? and content not like ?", user.id, "%Mock%")
          @artifacts = User.find_by(uuid: params[:uuid]).artifacts.where("content not like ?", "%Mock%")
      end
    else
      @artifacts = User.find_by(id: current_user.id).artifacts
    end
  end

  # GET /artifacts/1
  def show
    if @artifact.title.include? "/" # to check if it is a fom_exams file
      file_name = ActiveStorage::Attachment.find(@artifact.documents.first.id).blob.filename.to_s
      file_name = File.basename(file_name, File.extname(file_name)) ## without file extension
      permission_group_id, course_code, component = @artifact.title.split("/")
      sub_component = @artifact.content
      if sub_component == 'labels'
        cohort_title = PermissionGroup.find(permission_group_id).title.split("(").last.gsub(")", "")
        file_name = cohort_title + "_" + course_code + "_" + component
      else
        file_name = permission_group_id + "_" + course_code + "_" + sub_component
      end
      file_name = "#{Rails.root}/log/fom_exams/#{file_name}.log"
      @myFile=File.open(file_name,"r")
    end

  end

  def get_sub_components
    if params[:permission_group_id].present? and params[:course_code].present?
      labels = FomLabel.find_by(permission_group_id: params[:permission_group_id], course_code: params[:course_code]).labels
      labels = JSON.parse(labels)
      @labels = hf_filter_fom_labels(params[:component], labels)
    end
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {sub_components: @labels}
        }
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end

  # GET /artifacts/new
  def new
    @artifact = Artifact.new
    @student_groups = PermissionGroup.select(:id, :title).where(" id >= ? and id <> ?", 16, 15).order(:title)
    @cohort_students = []
    @course_codes = []
    if params[:file_type].present?
      @file_type = params[:file_type]
    end
    if params[:permission_group_id].present?
      if @file_type == 'Regular'
        @cohort_students = User.select(:id, :full_name).where(permission_group_id: params[:permission_group_id]).order(:full_name)
      elsif @file_type == 'FoM'
        @course_codes = FomLabel.select(:id, :course_code).where(permission_group_id: params[:permission_group_id]).order(:course_code)
        @course_codes = @course_codes.collect{|s| [s.course_code]}.push ["New Block"]
        @course_codes = @course_codes.flatten
      end
    end
    if request.xhr?
      if @file_type == 'Regular'
        respond_to do |format|
          format.json {
            render json: {cohort_students: @cohort_students}
          }
        end
      elsif @file_type == 'FoM'
        respond_to do |format|
          format.json {
            render json: {course_codes: @course_codes}
          }
        end
      end
    else
      respond_to do |format|
        format.html
      end
    end

  end

  # GET /artifacts/1/edit
  def edit
  end

  # POST /artifacts
  def create
    @artifact = Artifact.new(artifact_params)
    if params[:user_id].present?
      @artifact.user_id = params[:user_id].to_i
    else
      @artifact.user_id = current_user.id
    end
    if params[:course_code].present?
      if params[:course_code] == 'New Block'
        @artifact.title = params[:permission_group_id] + "/" + @artifact.title  + "/" + 'labels'
        @artifact.content = 'labels'
      else
        @artifact.title = params[:permission_group_id] + "/" + params[:course_code] + "/" + @artifact.title
      end
    end

    if @artifact.save
      if params[:course_code].present? and current_user.coaching_type == 'admin'
        ## to check whether it is a label file
        if params[:course_code] == 'New Block'
          hf_load_label_file(@artifact)
        else
          @log_messages = hf_fom_process_file(@artifact)
        end

      end
      redirect_to @artifact, notice: 'Artifact was successfully created.'
    else
      redirect_to @artifact, notice: 'Error Invalid File Type - only allowed PDF, JPEG, JPG & PNG!'

    end
  end

  # PATCH/PUT /artifacts/1
  def update
    if @artifact.update(artifact_params)
      redirect_to @artifact, notice: 'Artifact was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /artifacts/1
  def destroy
    @artifact.destroy
    redirect_to artifacts_url, notice: 'Artifact was successfully destroyed.'
  end

  def delete_document_attachment
    @artifact_document = ActiveStorage::Blob.find_signed(params[:id])
    #@artifact = Artifact.find(@artifact_document.attachments.first.record_id)
    @artifact_document.attachments.first.purge
    redirect_to artifacts_url, notice: 'Document was successfully purged!'

  end

  def move_files
    @artifact = Artifact.find(params[:id])
    move_file_to_user(@artifact)
  end

  def step_2_move_files
    @artifact = Artifact.find(params[:id])
    step2_move_files_to_user(@artifact)
  end

  def process_preceptor_eval
    @artifact = Artifact.find(params[:id])
    @log_results = Artifact.process_upload_data(@artifact, 'PreceptorEval')
  end

  def process_formative_feedback
    @artifact = Artifact.find(params[:id])
    @log_results = Artifact.process_upload_data(@artifact, 'FormativeFeedback')
  end

  def process_informatics_feedback
    @artifact = Artifact.find(params[:id])
    @log_results = Artifact.process_upload_data(@artifact, 'InformaticsFeedback')
  end

  def process_comp_excel
    @artifact = Artifact.find(params[:id])
    Artifact.read_competency_excel(@artifact)
    todayDate = Time.now.strftime("%Y_%m_%d")
    filename = "#{Rails.root}/log/competency_#{todayDate}.log"
    render file: filename
  end

  def process_bls_excel
    @artifact = Artifact.find(params[:id])
    Artifact.read_bls_excel(@artifact)
    todayDate = Time.now.strftime("%Y_%m_%d")
    filename = "#{Rails.root}/log/bls_#{todayDate}.log"
    render file: filename
  end

  def ultimate_method
      @problem_artifact  = Artifact.find(params[:id])
      @moved_files = []
      @problem_artifact.documents.each do |document|
        data_array = []
        data_array.push document.filename
        sid = hf_get_user_document(document)

        student_user = User.find_by(sid: sid)
        if !student_user.nil?
          full_name = student_user.full_name

          data_array.push full_name
          data_array.push sid

          temp_artifact = Artifact.find_or_create_by(user_id: student_user.id, content: @problem_artifact.content, title: @problem_artifact.title) do |a|
            a.content = @problem_artifact.content
            a.title = @problem_artifact.title
            a.documents.attach(ActiveStorage::Blob.find(document.blob_id))
          end
          if !temp_artifact.documents.exists?(blob_id: document.blob_id)
             temp_artifact.documents.attach(ActiveStorage::Blob.find(document.blob_id))
          end
          document.destroy # remove it from the artifact
          @moved_files.push data_array
        else
          data_array.push full_name
          data_array.push sid + " - Not Found in User Table!"
          @moved_files.push data_array
        end

      end
  end
  def bulk_remove
    @bulk_remove_files = []
    if params[:Cohort].present? and params[:BlockCode].present? and params[:FileType].present?
      permission_group = PermissionGroup.where('title like ?', '%Med28%').first
      #users = ["1983", "2043", "1941", "1977"]
      @bulk_remove_files = Artifact.gather_files_to_delete(params[:Cohort], permission_group, params[:BlockCode], params[:FileType])
    end

  end

  def purge_all_documents
    if params[:content].present?
      file_path = Rails.root.join('public', "FoM_#{params[:content]}_#{params[:file_type]}.txt")
      CSV.foreach(file_path, col_sep: "\t", headers: true) do |row|
        artifact_id = row["artifact_id"]
        user_id = row["user_id"]
        title = row["title"]
        content = row["content"]
        file_type = row["file_type"]
        test_str = content + "_" + file_type
        artifact = Artifact.find_by(title: title, content: content, id: artifact_id, user_id: user_id)
        artifact.documents.each do |document|
          if document.filename.to_s.include? test_str
            document.purge
            artifact.destroy
          end
        end
      end
    end
  end

  private

    def move_file_to_user(artifact)

      artifact.documents.each do |document|
        #artifact_document = document.id #ActiveStorage::Blob.find_signed(params[:id])
        if !document.filename.to_s.include? "image00"  ## check to see if it is an image file from informatics feedback so that we can move to it
          temp_str = document.filename.to_s.split(" ")
          if temp_str.last.include? "Preceptorship"
            full_name = temp_str[0] + " " + temp_str[1]
          else
            temp_str2 = temp_str.first.split("_")
            if temp_str2.count == 1
               last_name = temp_str2.first
               temp_str3 = temp_str.second.split("_")
               last_name = last_name + " " + temp_str3.first
               first_name = temp_str3.second
               full_name = last_name + ", " + first_name
            elsif temp_str2.count >= 2
               full_name = temp_str2.first + ", " + temp_str2.second
            else
               return
             end
           end
          @student_user = User.find_by(full_name: full_name)
        else
          username = document.filename.to_s.split("_").first
          @student_user = User.find_by(username: username)
        end

        if !@student_user.nil?
          temp_artifact = Artifact.find_or_create_by(user_id: @student_user.id, content: artifact.content, title: artifact.title) do |a|
            a.content = artifact.content
            a.title = artifact.title
            a.documents.attach(ActiveStorage::Blob.find(document.blob_id))
          end
          if !temp_artifact.documents.exists?(blob_id: document.blob_id)
             temp_artifact.documents.attach(ActiveStorage::Blob.find(document.blob_id))
          end
          document.destroy # remove it from the artifact
        end
      end
    end

    def step2_move_files_to_user(artifact)
      nbme_match_file = "#{Rails.root}/config/Med26_NBME_Name_Match.txt"
      row_hash = {}
      CSV.foreach(nbme_match_file, col_sep: "\t", :headers => true, encoding: "UTF-8") do |row|
        row_hash.store(row["pdf_file"], row["email"])
      end
      artifact.documents.each do |document|
        email = row_hash[document.filename.to_s]
        student_user = User.find_by(email: email)
        if !student_user.nil?
          temp_artifact = Artifact.find_or_create_by(user_id: student_user.id, content: artifact.content, title: artifact.title) do |a|
            a.content = artifact.content
            a.title = artifact.title
            a.documents.attach(ActiveStorage::Blob.find(document.blob_id))
          end
          if !temp_artifact.documents.exists?(blob_id: document.blob_id)
             temp_artifact.documents.attach(ActiveStorage::Blob.find(document.blob_id))
          end
          document.destroy # remove it from the artifact
        end
      end

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_artifact
      @artifact = Artifact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def artifact_params
      params.require(:artifact).permit(:title, :content, :user_id, documents: [])
    end
end
