class MalesController < ApplicationController
  #あとで解除する
  #before_action :authenticate_male!, except: [:show]
  before_action :set_follow_ids, only: [:index, :unfollowing]
  before_action :set_male, only: [:index, :show, :edit, :update, :destroy, :unfollowing, :following, :profile_update, :unfollowing_index]

	def index
    if @male.profile_image_id
      image_id = @male.profile_image_id
      @male_post = MalePost.find(image_id)
      @male_posts = @male.male_posts.all
    #else  
      #@male_posts = @male.male_posts.all
      
    else
      @male_posts = @male.male_posts.all
    end

    @title = "フォローしている女医の投稿"
    #@lady_doctorsのlady_doctor_postすべてをcreated_atが新しい順のfirstをとってくる
    #followしている女性all

    follow_ids = Relationship.where(male_id: @male.id).pluck(:lady_doctor_id)
    @lady_doctor_posts = LadyDoctorPost.where(lady_doctor_id: follow_ids).all
    @comments = Like.where(male_id: @male.id).pluck(:comment)

	end

  def following
    #@lady_doctorsのlady_doctor_postすべてをcreated_atが新しい順のfirstをとってくる
    #followしている女性all
    follow_ids = Relationship.where(male_id: @male.id).pluck(:lady_doctor_id)
    @lady_doctor_posts = LadyDoctorPost.where(lady_doctor_id: follow_ids).all
  end

  def edit
  end

  def update
    respond_to do |format|
      if @male.update(male_params)
        format.html { redirect_to @male, notice: 'Male was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @male.errors, status: :unprocessable_entity }
      end
    end
  end

  def unfollowing
    #followしてない女医を全部とってくる
    follow_ids = Relationship.where(male_id: @male.id).pluck(:lady_doctor_id)
    @lady_doctors = LadyDoctor.where.not(id: follow_ids).all
  end

  def unfollowing_index
    @lady_doctor = LadyDoctor.find(params[:id])
    if @lady_doctor.profile_image_id
      image_id = @lady_doctor.profile_image_id
      @lady_doctor_post = LadyDoctorPost.find(image_id)
      @lady_doctor_posts = @lady_doctor.lady_doctor_posts.all
    else
      @lady_doctor_posts = @lady_doctor.lady_doctor_posts.all
    end
    #@lady_doctor_post = LadyDoctorPost.find(params[:lady_doctor_post_id])
    #@male = Male.find(params[:male_id])
    #@lady_doctor = LadyDoctor.find(params[:id])
    #@lady_doctor_posts = @lady_doctor.lady_doctor_posts.all
  end

  def show
    if @male.profile_image_id
      image_id = @male.profile_image_id
      @male_post = MalePost.find(image_id)
      @male_posts = @male.male_posts.all
    #else  
      #@male_posts = @male.male_posts.all
      
    else
      @male_posts = @male.male_posts.all
    end
  end
  
  def destroy
    @male.destroy
    respond_to do |format|
      format.html { redirect_to new_male_session_path, notice: 'Male user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def profile_update
    @male_post = MalePost.find(params[:id])
    @male.profile_image_id = @male_post.id

    respond_to do |format|
      if @male.save
        format.html { redirect_to male_path(id: @male.id), notice: 'Profile Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @male.errors, status: :unprocessable_entity }
      end
    end
  end

  def lady_doctor_posts_show
    @male = Male.find(params[:male_id])
    @lady_doctor_post = LadyDoctorPost.find(params[:id])
    @lady_doctor = @lady_doctor_post.lady_doctor
    @male_post_comments = MalePostComment.where(lady_doctor_post_id: @lady_doctor_post.id, male_id: @male.id).all
  end
  
  def lady_doctor_index
    @lady_doctor_post = LadyDoctorPost.find(params[:lady_doctor_post_id])
    @male = Male.find(params[:male_id])
    @lady_doctor = LadyDoctor.find(params[:id])
    @lady_doctor_posts = @lady_doctor.lady_doctor_posts.all
  end


  def following?(lady_doctor)
    following_relationships.find_by(lady_doctor_id: lady_doctor.id)
  end

  def follow!(lady_doctor)
    following_relationships.create!(lady_doctor_id: lady_doctor.id)
  end

  def unfollow!(lady_doctor)
    following_relationships.find_by(lady_doctor_id: lady_doctor.id).destroy
  end
  



  private
  
  #
  def male_params
    params.require(:male).permit(:name, :email, :age, :sex, :school, :work, :annual_income, :password, :password_confirmation)
  end

  def set_male    
    @male = current_male || Male.find(params[:id])
  end

  def set_follow_ids
    follow_ids = Relationship.where(male_id = current_male.id).pluck(:lady_doctor_id)
  end



end
