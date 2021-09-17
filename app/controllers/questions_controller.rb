class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy]

  after_action :publish_question, only: [:create]

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

  def publish_question
    return if @question.errors.any?
    
    ActionCable.server.broadcast(
      'questions', 
      render_question
    )
  end

  def render_question
    QuestionsController.renderer.instance_variable_set(
      :@env, {
        "HTTP_HOST"=>"localhost:3000", 
        "HTTPS"=>"off", 
        "REQUEST_METHOD"=>"GET", 
        "SCRIPT_NAME"=>"",   
        "warden" => warden
      }
    )
  
    QuestionsController.render(
      partial: 'questions/question',
      locals: { 
        question: @question,
        current_user: current_user
      }
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], reward_attributes: [:description, :image], links_attributes: [:name, :url, :_destroy])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
