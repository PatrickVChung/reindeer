class MedhubApisController < ApplicationController
  layout 'full_width_csl'
  protect_from_forgery prepend: true, with: :exception
  before_action :authenticate_user!, :set_resources
  include MedhubApisHelper

  def final_evals
    if params[:course_ids].present?
      if params[:EnabledDebug].present?
        debug = 'Y'
      else
        debug = 'N'
      end
      @evals_log = hf_access_medhub(params[:course_ids], debug)
      medhub_api_log_file_path = Rails.root.join('log', 'medhub_api.log')
      @medhub_api_log_content = File.read(medhub_api_log_file_path)
      respond_to do |format|
        format.html
      end
    end


  end

  def all_courses

  end

  def get_courses

    if params[:course_code].present?
      @courses = MedhubCourse.where("course_name like ?", "%#{params[:course_code]}%")
      respond_to do |format|
        format.html
        format.js { render action: 'course_data', status: 200 }
      end
    end

  end

  private

  def set_resources
    medhub_api_log_file_path = Rails.root.join('log', 'medhub_api.log')
    File.open(medhub_api_log_file_path, "w") { |file| file.truncate(0) }
  end
end
