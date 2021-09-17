class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_answer, only: [:destroy, :update, :nominate]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    if @answer.save
      flash[:notice] = 'Your answer successfully posted.'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
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
    @question = @answer.question
    @answer.choose_as_best
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
  
  def answer_params
    params.require(:answer).permit(:title, :body, files: [], links_attributes: [:name, :url])
  end
end
