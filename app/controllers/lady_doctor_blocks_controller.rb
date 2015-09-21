class LadyDoctorBlocksController < ApplicationController
  before_action :set_male, only: [:create]
  before_action :set_lady_doctor, only: [:create]

  def create
   @lady_doctor_block = LadyDoctorBlock.new(lady_doctor_id: @lady_doctor.id, male_id: @male.id)
   respond_to do |format|
     if @lady_doctor_block.save
        format.html { redirect_to :back, notice: "#{@male.name}をブロックしました" }
        format.json { head :no_content }
     else
        format.html { redirect_to :back, notice: "#{@male.name}をブロックできませんでした" }
        format.json { render json: @lady_doctor.errors, status: :unprocessable_entity }
     end
   end

  end

  def destroy
  	@male = Male.find(params[:male_id])
  	#@lady_doctor = LadyDoctor.find(params[:lady_doctor_id])
  	#@lady_doctor_block = LadyDoctorBlock.find_by(male_id: @male.id, lady_doctor_id: @lady_doctor.id)
    @lady_doctor_block = LadyDoctorBlock.find(params[:id])
  	#@like = Like.where(male_id: @male.id, lady_doctor_id: @lady_doctor.id).first
  	@lady_doctor_block.destroy

  	respond_to do |format|
  	  format.html { redirect_to :back, notice: "#{@male.name}へのblockをキャンセルしました" }
      format.json { head :no_content }
    end
  end

  private

  def set_male
    @male = Male.find(params[:id])
  end

  def set_lady_doctor
    @lady_doctor = LadyDoctor.find(params[:lady_doctor_id])
  end
end
