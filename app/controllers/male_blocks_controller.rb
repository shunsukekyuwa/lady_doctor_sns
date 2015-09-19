class MaleBlocksController < ApplicationController
  before_action :set_male, only: [:create]
  before_action :set_lady_doctor, only: [:create]

  def create
   @male_block = MaleBlock.new(male_id: @male.id, lady_doctor_id: @lady_doctor.id)
   respond_to do |format|
     if @male_block.save
        format.html { redirect_to :back, notice: "#{@lady_doctor.name}をブロックしました" }
        format.json { head :no_content }
     else
        format.html { redirect_to :back, notice: "#{@lady_doctor.name}をブロックできませんでした" }
        format.json { render json: @male.errors, status: :unprocessable_entity }
     end
   end

  end

  def destroy
  	@male = Male.find(params[:male_id])
  	@lady_doctor = LadyDoctor.find(params[:lady_doctor_id])
  	@male_block = MaleBlock.find_by(male_id: @male.id, lady_doctor_id: @lady_doctor.id)
  	#@like = Like.where(male_id: @male.id, lady_doctor_id: @lady_doctor.id).first
  	@male_block.destroy

  	respond_to do |format|
  	  format.html { redirect_to :back, notice: "#{@lady_doctor.name}へのblockをキャンセルしました" }
      format.json { head :no_content }
    end
  end

  private

  def set_male
    @male = current_male
  end

  def set_lady_doctor
    @lady_doctor = LadyDoctor.find(params[:id])
  end


end
