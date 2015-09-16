class RelationshipsController < ApplicationController
  before_action :set_male
  before_action :set_lady_doctor

  def create
   @relationship = Relationship.new(male_id: @male.id, lady_doctor_id: @lady_doctor.id)
   respond_to do |format|
     if @relationship.save
        format.html { redirect_to unfollowing_male_path(id: @male.id), notice: "#{@lady_doctor.name}をフォローしました" }
        format.json { head :no_content }
     else
        format.html { render action: unfollowing_male_path(@male) }
        format.json { render json: @lady_doctor.errors, status: :unprocessable_entity }
     end
   end

  end

  def destroy
  end

  private

  def set_male
    @male = current_male
  end

  def set_lady_doctor
    @lady_doctor = LadyDoctor.find(params[:id])
  end
end
