class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    if @answer.save
      flash[:notice] = 'Your answer successfully posted.'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted'
    else
      flash[:alert] = 'You are not a author!'
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
  end

  private
  
  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end
