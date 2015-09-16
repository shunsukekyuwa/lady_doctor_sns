class LikesController < ApplicationController
  before_action :set_male, only: [:create]
  before_action :set_lady_doctor

  def create
   @like = Like.new(male_id: @male.id, lady_doctor_id: @lady_doctor.id)
   @like.comment = @lady_doctor.email

   respond_to do |format|
     if @like.save
        format.html { redirect_to lady_doctors_path, notice: "#{@male.name}をlikeしました" }
        format.json { head :no_content }
     else
        format.html { render action: lady_doctors_path }
        format.json { render json: @lady_doctor.errors, status: :unprocessable_entity }
     end
   end
  end

  def destroy
  	#@like = Like.find(params[:like_id])
  	@male = Male.find(params[:male_id])
  	@like = Like.find_by(male_id: @male.id, lady_doctor_id: @lady_doctor.id)
  	#@like = Like.where(male_id: @male.id, lady_doctor_id: @lady_doctor.id).first
  	@like.destroy

  	respond_to do |format|
  	  format.html { redirect_to lady_doctors_path, notice: "#{@male.name}へのlikeをキャンセルしました" }
      format.json { head :no_content }
    end
  end

  private

  def set_male
    @male = Male.find(params[:id])
  end

  def set_lady_doctor
    @lady_doctor = current_lady_doctor
  end
end
