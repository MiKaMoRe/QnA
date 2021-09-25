class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_answer, only: [:destroy, :update, :nominate]

  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    if @answer.save
      flash[:notice] = 'Your answer successfully posted.'
    end
  end

  def destroy
    if can?(:manage, @answer)
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted'
    else
      flash[:alert] = 'You are not a author!'
    end
  end

  def update
    @answer.update(answer_params)
  end

  def nominate
    authorize! :nominate, @answer
    @question = @answer.question
    @answer.choose_as_best
  end

  private

  def publish_answer
    return if @answer.errors.any?
    
    ActionCable.server.broadcast(
      'answers', 
      {
        answer: @answer,
        current_user: current_user,
        create_comment_token: form_authenticity_token
      }.to_json
    )
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
  
  def answer_params
    params.require(:answer).permit(:title, :body, files: [], links_attributes: [:name, :url])
  end
end
