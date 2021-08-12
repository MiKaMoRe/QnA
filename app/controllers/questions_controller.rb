class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
    @answers = Answer.all
  end

  def create
    @question = current_user.created_questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    @question = Question.find(params[:id])

    if @question.author == current_user
      @question.destroy
      redirect_to root_path, notice: 'Question successfully deleted'
    else
      redirect_to root_path, alert: 'You are not a author!'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
