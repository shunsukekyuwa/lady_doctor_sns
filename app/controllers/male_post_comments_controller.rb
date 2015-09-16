class MalePostCommentsController < ApplicationController

	before_action :set_male_post_comment, only: [:edit, :update, :destroy]
  
  def new
  	@male = Male.find(params[:male_id])
  	@lady_doctor_post = LadyDoctorPost.find(params[:id])
  	@lady_doctor = @lady_doctor_post.lady_doctor
  	p "#{@lady_doctor}"
  	@male_post_comment = MalePostComment.new
  end

  def create
  	# current_male == nil
  	if current_male.nil?
  	  #女性からのコメント
  	  @male = current_male
      @male_post_comment = @lady_doctor.male_post_comments.build(male_post_comment_params)
    else
      #男からのコメント
      @male = current_male
      @male_post_comment = @male.male_post_comments.build(male_post_comment_params)
    end

    respond_to do |format|
	  #saveされたら showへ飛ばす。されなかったらもう一度new画面に戻る
      if @male_post_comment.save
        format.html { redirect_to males_path, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: males_path }
      else
        format.html { render :new }
        format.json { render json: @male_post_comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @male_post_comment = MalePostComment.find(params[:id])
    @male = @male_post_comment.male
    @lady_doctor_post = @male_post_comment.lady_doctor_post
  end

  def update
  	@male = @male_post_comment.male
  	@lady_doctor_post = @male_post_comment.lady_doctor_post
  	
  	respond_to do |format|
	  	#saveされたら showへ飛ばす。されなかったらもう一度new画面に戻る
        if @male_post_comment.update(male_post_comment_params)
          format.html { redirect_to lady_doctor_posts_show_path(male_id: @male.id, id: @lady_doctor_post.id), notice: 'Comment was successfully updated.' }
          format.json { render :show, status: :created, location: lady_doctor_posts_show_path(male_id: @male.id, id: @lady_doctor_post.id) }
        else
          format.html { render :new }
          format.json { render json: @male_post.errors, status: :unprocessable_entity }
        end
      end	  
  end

  def destroy
  	@male = @male_post_comment.male
  	#lady_doctor_post_id = @male_post_comment.lady_doctor_post_id
  	#@lady_doctor_post = LadyDoctorPost.where(id: lady_doctor_post_id)
    
    #@male_post_comment.destroy
    @lady_doctor_post = @male_post_comment.lady_doctor_post
    @male_post_comment.destroy
	respond_to do |format|
      format.html { redirect_to lady_doctor_posts_show_path(male_id: @male.id, id: @lady_doctor_post.id), notice: 'comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private 

  def male_post_comment_params
	params.require(:male_post_comment).permit(:comment, :lady_doctor_post_id)
  end

  def set_male_post_comment
	@male_post_comment = MalePostComment.find(params[:id])
  end

  def set_male
  	@male = current_male
  end
end
