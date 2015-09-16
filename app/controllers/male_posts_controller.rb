class MalePostsController < ApplicationController
	before_action :authenticate_male!
	before_action :set_male_post, only: [:show, :edit, :update, :destroy]
    before_action :set_male, only: [:new, :create, :index, :update, :destroy]

	def index
      @male_post = MalePost.all
	end
    
	def new
	  @male_post = MalePost.new
	end

	def create
	  @male_post = @male.male_posts.build(male_post_params)

	  respond_to do |format|
	  	#saveされたら showへ飛ばす。されなかったらもう一度new画面に戻る
        if @male_post.save
          format.html { redirect_to male_path(id: @male.id), notice: 'Post was successfully created.' }
          format.json { render :show, status: :created, location: male_path(id: @male.id) }
        else
          format.html { render :new }
          format.json { render json: @male_post.errors, status: :unprocessable_entity }
        end
      end
	end

	def show
	end

	def edit
	  @male = @male_post.male(params[:id])
	end

	def update
      respond_to do |format|
	  	#saveされたら showへ飛ばす。されなかったらもう一度new画面に戻る
        if @male_post.update(male_post_params)
          format.html { redirect_to @male, notice: 'Post was successfully updated.' }
          format.json { render :show, status: :created, location: @male }
        else
          format.html { render :new }
          format.json { render json: @male_post.errors, status: :unprocessable_entity }
        end
      end	  

	end

	def destroy
	  @male_post.destroy
	  respond_to do |format|
        format.html { redirect_to @male, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end
	end

	private

	#male_postのcontent,imageのみ更新可能
	def male_post_params
	  params.require(:male_post).permit(:content, :image)
	end

	def set_male_post
	  @male_post = MalePost.find(params[:id])
	end

	def set_male    
      @male = current_male
    end

end
