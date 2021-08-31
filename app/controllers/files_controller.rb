class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :purge_file, only: [:question_destroy, :answer_destroy]

  def question_destroy
    @question = Question.find(params[:question_id])
  end

  def answer_destroy
    @answer = Answer.find(params[:answer_id])
  end

  private

  def purge_file
    @file = ActiveStorage::Attachment.find(params[:file_id])
    if current_user.author_of?(@file.record)
      @file.purge
      flash[:notice] = 'File successfully deleted'
    else
      flash[:alert] = 'You are not a author!'
    end
  end
end
