class LadyDoctorsController < ApplicationController
  before_action :authenticate_lady_doctor!, except: [:show]
  before_action :set_lady_doctor, only: [:index, :show, :edit, :update, :destroy, :profile_update]
  
  def index
    if @lady_doctor.confirm_state
  #followされているmale全て
    @title = "Follower"
	  followed_ids = Relationship.where(lady_doctor_id: @lady_doctor.id).pluck(:male_id)
    @males = Male.where(id: followed_ids).all

    else
      render 'waiting'
    end
    if @lady_doctor.profile_image_id
      image_id = @lady_doctor.profile_image_id
      @lady_doctor_post = LadyDoctorPost.find(image_id)
    end

  end

  

  def show
    if @lady_doctor.profile_image_id
      image_id = @lady_doctor.profile_image_id
      @lady_doctor_post = LadyDoctorPost.find(image_id)
      @lady_doctor_posts = @lady_doctor.lady_doctor_posts.order(created_at: :desc).all
    else
      @lady_doctor_posts = @lady_doctor.lady_doctor_posts.order(created_at: :desc).all
    end
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if @lady_doctor.update(lady_doctor_params)
        format.html { redirect_to @lady_doctor, notice: 'LadyDoctor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lady_doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  def profile_update
    @lady_doctor_post = LadyDoctorPost.find(params[:id])
    @lady_doctor.profile_image_id = @lady_doctor_post.id

    respond_to do |format|
      if @lady_doctor.save
        format.html { redirect_to lady_doctor_path(id: @lady_doctor.id), notice: 'LadyDoctor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lady_doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lady_doctor.destroy
    respond_to do |format|
      format.html { redirect_to new_lady_doctor_session_path, notice: 'あなたのアカウントは削除しました' }
      format.json { head :no_content }
    end
  end

  def follow_show
    @male = Male.find(params[:id])
     if @male.profile_image_id
      image_id = @male.profile_image_id
      @male_post = MalePost.find(image_id)
     end
    @lady_doctor = LadyDoctor.find(params[:lady_doctor_id])
    @male_posts = @male.male_posts.order(created_at: :desc).all
  end

  def sending?(male)
    sending_likes.find_by(male_id: male.id)
  end

  private
  
  #
  def lady_doctor_params
    params.require(:lady_doctor).permit(:name, :email, :doctor_number, :age, :sex, :school, :work, :annual_income, :password, :password_confirmation, :confirm_state, :profile_image_id)
  end

  def set_lady_doctor    
    @lady_doctor = current_lady_doctor || LadyDoctor.find(params[:id])
  end

  def sign_in?
    current_lady_doctor.confirm_state?
  end

end
