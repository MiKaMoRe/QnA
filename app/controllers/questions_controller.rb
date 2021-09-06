class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy]

  def index
    @questions = Question.all
    @question = Question.new
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_reward
  end

  def show
    @answer = Answer.new
    @answer.links.build
  end

  def create
    @question = current_user.created_questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :create
    end
  end

  def destroy
    @question = Question.find(params[:id])

    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Question successfully deleted'
    else
      flash[:alert] = 'You are not a author!'
    end
  end

  def update
    @question = Question.find(params[:id])
    @question.update(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [], reward_attributes: [:description, :image], links_attributes: [:name, :url])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
