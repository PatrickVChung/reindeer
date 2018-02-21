module Coaching
  class MeetingsController < ApplicationController

    def create
      @meeting = Meeting.create meeting_params

      respond_to do |format|
        if @meeting.save
          format.js { render action: 'show', status: :created }
        else
          format.js { render json: { error: @meeting.errors }, status: :unprocessable_entity }
        end
      end
    end

    def show_detail
      @meeting = Meeting.find(params[:id])

      respond_to do |format|
        format.js { render action: 'show_detail', status: :ok }
      end
    end

    def destroy
      @meeting = Meeting.find params[:id]

      redirect_to coaching_students_path && return unless current_user.admin_or_higher?

      respond_to do |format|
        if @meeting.destroy
          format.js { render action: 'destroy', status: :ok }
        else
          format.js { render json: @meeting.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def meeting_params
      params.require(:coaching_meeting)
      .permit(:subject, :notes, :location, :date, :status, :user_id)
    end
  end
end