class CreatePdfsController < ApplicationController
  layout 'full_width_margins'
  before_action :authenticate_user!
  include CreatePdfsHelper


  def create_and_move_pdf
    @artifact = User.find_by(id: current_user.id).artifacts.where(content: 'Q-Informatics Feedback Text File').first
    @filename = @artifact.documents.blobs.first.filename.to_s
  end

  def move_pdf
    if params[:Cohort].present? && params[:BlockCode].present? && params[:FileType].present?
      partial_filename = params[:Cohort] + "_" + params[:BlockCode] + params[:FileType]
      @pdf_log = hf_create_and_move(params[:artifact_id], params[:BlockCode], partial_filename, params[:header1],  params[:header2],  params[:header3])
    end

  end

end
