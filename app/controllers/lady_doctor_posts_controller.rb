class LadyDoctorPostsController < ApplicationController
	before_action :authenticate_lady_doctor!
	before_action :set_lady_doctor_post, only: [:show, :edit, :update, :destroy]
	before_action :set_lady_doctor, only: [:new, :create, :index, :update, :destroy]

	def index
      #@lady_doctor_post = LadyDoctorPost.all
	end
    
	def new
	  @lady_doctor_post = LadyDoctorPost.new
	end

	def create
	  @lady_doctor_post = @lady_doctor.lady_doctor_posts.build(lady_doctor_post_params)

	  respond_to do |format|
	  	#saveされたら showへ飛ばす。されなかったらもう一度new画面に戻る
        if @lady_doctor_post.save
          format.html { redirect_to lady_doctor_path(id: @lady_doctor.id), notice: 'Post was successfully created.' }
          format.json { render :show, status: :created, location: lady_doctor_path(id: @lady_doctor.id) }
        else
          format.html { render :new }
          format.json { render json: @lady_doctor_post.errors, status: :unprocessable_entity }
        end
      end
	end

	def show
	  @lady_doctor = LadyDoctor.find(params[:lady_doctor_id])
	  if @lady_doctor.profile_image_id
        image_id = @lady_doctor.profile_image_id
        @post = LadyDoctorPost.find(image_id)
      end
	  @lady_doctor_post = LadyDoctorPost.find(params[:id])
	  @male_post_comments = MalePostComment.where(lady_doctor_post_id: @lady_doctor_post.id)
	  @male
	end

	def edit
	  @lady_doctor = @lady_doctor_post.lady_doctor(params[:id])
	end

	def update
      respond_to do |format|
	  	#saveされたら showへ飛ばす。されなかったらもう一度new画面に戻る
        if @lady_doctor_post.update(lady_doctor_post_params)
          format.html { redirect_to @lady_doctor, notice: 'Post was successfully updated.' }
          format.json { render :show, status: :created, location: @lady_doctor }
        else
          format.html { render :new }
          format.json { render json: @lady_doctor_post.errors, status: :unprocessable_entity }
        end
      end	  

	end

	def destroy
	  @lady_doctor_post.destroy
	  respond_to do |format|
        format.html { redirect_to @lady_doctor, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end
	end

	private

	#male_postのcontentのみ更新可能
	def lady_doctor_post_params
	  params.require(:lady_doctor_post).permit(:content, :image)
	end

	def set_lady_doctor_post
	  @lady_doctor_post = LadyDoctorPost.find(params[:id])
	end

	def set_lady_doctor
	  @lady_doctor = current_lady_doctor
	end

end
