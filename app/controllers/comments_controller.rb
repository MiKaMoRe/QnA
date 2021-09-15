class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @commentable = params[:commentable_type].constantize.find(params[commentable_id])
    @comment = @commentable.comments.build(comment_params)
    @comment.assign_attributes( commentable: @commentable, author: current_user)

    if @comment.save
      flash[:notice] = 'Your comment successfully posted.'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    if current_user.author_of?(@comment)
      @comment.destroy
      flash[:notice] = 'Comment successfully deleted'
    else
      flash[:alert] = 'You are not a author!'
    end
  end

  private

  def commentable_id
    "#{params[:commentable_type]}_id".downcase.to_sym
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
