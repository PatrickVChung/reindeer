class UmeAssessPlansController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  before_action :set_ume_assess_plan, only: %i[ show edit update destroy ]

  # GET /ume_assess_plans or /ume_assess_plans.json
  def index
    @ume_assess_plans = UmeAssessPlan.all.order(:id)
  end

  # GET /ume_assess_plans/1 or /ume_assess_plans/1.json
  def show
  end

  # GET /ume_assess_plans/new
  def new
    @ume_assess_plan = UmeAssessPlan.new
  end

  # GET /ume_assess_plans/1/edit
  def edit
  end

  # POST /ume_assess_plans or /ume_assess_plans.json
  def create
    @ume_assess_plan = UmeAssessPlan.new(ume_assess_plan_params)

    respond_to do |format|
      if @ume_assess_plan.save
        format.html { redirect_to @ume_assess_plan, notice: "Ume assess plan was successfully created." }
        format.json { render :show, status: :created, location: @ume_assess_plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ume_assess_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ume_assess_plans/1 or /ume_assess_plans/1.json
  def update
    respond_to do |format|
      if @ume_assess_plan.update(ume_assess_plan_params)
        format.html { redirect_to @ume_assess_plan, notice: "Ume assess plan was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @ume_assess_plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ume_assess_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ume_assess_plans/1 or /ume_assess_plans/1.json
  def destroy
    @ume_assess_plan.destroy!

    respond_to do |format|
      format.html { redirect_to ume_assess_plans_path, notice: "Ume assess plan was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def update_plans
    if params[:year] && params[:start_date].present? && params[:end_date].present?
     # @update_clinical_exp_log = UmeAssessPlan.update_clinical_exp(params[:year], params[:start_date], params[:end_date], params[:cohort])
     # @update_core_clinical_exp_log = UmeAssessPlan.update_core_clinical_exp(params[:year], params[:start_date], params[:end_date], params[:cohort])
     # @update_cpx_log = UmeAssessPlan.update_cpx(params[:year], params[:start_date], params[:end_date])
     # @update_tran_704_log = UmeAssessPlan.update_trans_704(params[:year], params[:start_date], params[:end_date])
     @update_preceptors_log = UmeAssessPlan.update_preceptor(params[:year], params[:start_date], params[:end_date])
     @update_narrative_log = UmeAssessPlan.update_narrative(params[:year], params[:start_date], params[:end_date])
     @update_scholarly_project_log = UmeAssessPlan.update_scholarly_project(params[:year], params[:start_date], params[:end_date])
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ume_assess_plan
      @ume_assess_plan = UmeAssessPlan.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ume_assess_plan_params
      params.expect(ume_assess_plan: [ :year, :competency, :student_learning_objective, :assessment_description, :method, :target, :resource, :target_met, :target_results, :rubric_used])
    end
end
