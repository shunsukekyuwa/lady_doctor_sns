class AdminsController < ApplicationController

  def index
  	#confirm_state がfalseの女医一覧
    @lady_doctors = LadyDoctor.where(confirm_state: 0).all
  end

  def confirm
  	@lady_doctor = LadyDoctor.find(params[:id])
  	@lady_doctor.confirm_state = true
  	@lady_doctor.save
  	#@lady_doctor.save(lady_doctor_params)
  	respond_to do |format|
        format.html { redirect_to admins_path, notice: '承認されました' }
        format.json { head :no_content }
    end
  end

  private
  def lady_doctor_params
    params.require(:lady_doctor).permit(:name, :email, :doctor_number, :age, :sex, :school, :work, :annual_income, :password, :password_confirmation, :confirm_state)
  end
end

