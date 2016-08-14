class CommentsController < ApplicationController
	before_action :find_post

	def create
		@comment = @post.comments.create(params[:comment].permit(:comment))
		@comment.user_id = current_user.id if current_user	

		if @comment.save
			redirect_to post_path(@post)
		else
			render 'posts/show'
		end
	end

	def edit
		@comment = @post.comments.find(params[:id])
	end

	def update
		@comment = @post.comments.find(params[:id])

		if @comment.update(params[:comment].permit(:comment))
			redirect_to post_path(@post)
		else
			render 'edit'
		end
	end

	def destroy	
		@comment = @post.comments.find(params[:id])
		@comment.destroy
		redirect_to post_path(@post)
	end	


	private

	def find_post
		@post = Post.find(params[:post_id])
	end

end