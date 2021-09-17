class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: [:create]

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

  def publish_comment
    return if @comment.errors.any?
    
    ActionCable.server.broadcast(
      'comments', 
      resource_name: @comment.commentable.class.name.downcase,
      resource_id: @comment.commentable.id,
      comment: render_comment
    )
  end

  def render_comment
    CommentsController.renderer.instance_variable_set(
      :@env, {
        "HTTP_HOST"=>"localhost:3000", 
        "HTTPS"=>"off", 
        "REQUEST_METHOD"=>"GET", 
        "SCRIPT_NAME"=>"",   
        "warden" => warden
      }
    )
  
    CommentsController.render(
      partial: 'comments/comment',
      locals: { 
        comment: @comment,
        current_user: current_user
      }
    )
  end

  def commentable_id
    "#{params[:commentable_type]}_id".downcase.to_sym
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end