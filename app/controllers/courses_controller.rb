class CoursesController < ApplicationController
  layout 'full_width_csl'
  before_action :authenticate_user!
  before_action :set_resources, only: %i[ index show edit update destroy ]
  include NewCompetenciesHelper
  include CoursesHelper


  def index

    if params[:searchWord].present?
      searchWord = params[:searchWord].strip
      @courses = Course.search(searchWord).order(:course_number)  # the scope is in model
      #@courses = @courses.available_and_has_comment  # has 0 seat and comments exist, and the scope in model

    else
      selected_course_types  = params[:course_types] || []
      selected_departments  = params[:departments] || []
      selected_durations    = params[:durations] || []
      selected_content_types= params[:content_types] || []
      selected_course_info  = params[:course_info] || []
      selected_competencies = params[:competencies] || []
      selected_offerings    = params[:offerings] || []
      selected_prerequisites= params[:prerequisites] || []
      selected_offerings    = params[:offerings].map{|o| o.split(": ").second} if params[:offerings].present? # only interesed on the block not the year
      selected_years        = params[:offerings].map{|o| o.split(": ").first} if params[:offerings].present?

      @courses = Course.all.order(:course_number)
      @courses = @courses.where(course_type: selected_course_types) if params[:course_types].present?
      @courses = @courses.where(department: selected_departments) if params[:departments].present?
      @courses = @courses.where(content_type: selected_content_types) if params[:content_types].present?
      @courses = @courses.where(duration: selected_durations) if params[:durations].present?
      @courses = @courses.where(prerequisites: selected_prerequisites) if params[:prerequisites].present?

      if params[:offerings].present?
        @courses = @courses
          .joins(:course_schedules)
          .where(course_schedules: { year: selected_years, block: selected_offerings })
          .where.not(course_schedules: { no_of_seats: [0, nil], comment: [nil] })
      end

      # 1. Initialize an array to hold all matching queries
      queries = []

      # 2. Collect conditions based on what is included
      queries << Course.where(available_through_the_lottery: true)  if selected_course_info.include?("Lottery")
      queries << Course.where(available_through_the_lottery: false) if selected_course_info.include?("Non-Lottery")
      queries << Course.where(rural: true)                          if selected_course_info.include?("Rural")
      queries << Course.where(continuity: true)                     if selected_course_info.include?("Continuity")
      #
      #     # 3. Handle the fallback else logic
      # if queries.empty? && params[:course_info].present?
      #   queries << Course.where(content_type: selected_course_info)
      # end

      # 4. Reduce the array into a single .or query and merge it into @courses
      if queries.any?
        combined_query = queries.reduce(:or)
        @courses = @courses.merge(combined_query)
      end

      @courses = @courses.where("competencies && ARRAY[?]", selected_competencies) if params[:competencies].present?
    end

  end

  # GET /courses/1 or /courses/1.json
  def show
      @course = Course.find(params[:id])
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
     @course = Course.find(params[:id])
     @course.course_schedules.build if @course.course_schedules.empty?

  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    @course = Course.find(params[:id])
    @course.competencies = params[:compChecked]

    respond_to do |format|
      if @course.update(course_params)
        #@course_changes = @course.previous_changes
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:course_number, :course_name, :content_type, :medhub_course_id, :rural,
        :continuity, :available_through_the_lottery, :department, :course_purpose_statement, :special_notes, :prerequisites,
        :required_prerequisites, :waive_prereq_requirements, :waive_notes, :duration, :site, :weekly_workload, :credits,
        :course_director, :course_director_email, :course_coordinator, :course_coordinator_email, :grading_method, :qualified_assessor, :qualified_assessor_email,
        :competency_note, :competencies, :enrollment_instructions, :admin_notes,
        course_schedules_attributes: [
              :id,
              :course_id,
              :year,
              :block,
              :start_date,
              :end_date,
              :no_of_seats,
              :comment,
              :_destroy
            ]
        )

    end

    def set_resources

      @course_type_count ||= Course.group(:course_type).count.sort.to_h
      @course_types = @course_type_count.keys
      @department_count ||= Course.group(:department).count.sort.to_h
      @departments = @department_count.keys  #Course.all.pluck(:department).uniq.compact.sort
      @duration_count ||= Course.group(:duration).count.sort.to_h
      @durations ||= hf_custom_sort(@duration_count.keys )

      @offering_count = CourseSchedule.group(:year, :block).count.to_h
      @offering_count = @offering_count.transform_keys {|year, term| "#{year}: #{term}"}
      @offerings ||= hf_seasonal_sort(@offering_count.keys)

      @content_type_count ||= Course.where("content_type not like '%Core%' and content_type <> 'Assessment' and content_type <> 'Intersession'").group(:content_type).count.sort.to_h
      @content_types = @content_type_count.keys

      @course_info = ["Lottery", "Non-Lottery", "Rural", "Continuity"]
      #@course_info = ["Lottery", "Non-Lottery", "Rural", "Continuity", "Clinical", "Non-Clinical", "Special Elective", "Sub-I/Acting Intern"]
      lottery_data ||= Course.group(:available_through_the_lottery).count
      rural_data ||= Course.group(:rural).count
      continuity_data = Course.group(:continuity).count
      @course_info_count = {}
      @course_info_count["Lottery"] = lottery_data[true]
      @course_info_count["Non-Lottery"] = lottery_data[false]
      @course_info_count["Rural"] = rural_data[true]
      @course_info_count["Continuity"] = continuity_data[true]

      sc ||= CourseSchedule.select(:year, :block).distinct.where.not(year: nil).order(:year)
      @course_schedules = sc.map{|s| s.year.to_s + " " + s.block}

      #@courses ||= Course.where(category: 'Core').order(:course_number)
      @competencies_count ||= Course.competencies_count
      #@courses_hash = @courses.map(&:attributes)
      #@course_col_names = Course.column_names

    end
end
