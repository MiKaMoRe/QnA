class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :purge_file, only: [:question_destroy, :answer_destroy]

  def question_destroy
    @question = @file.record
  end

  def answer_destroy
    @answer = @file.record
  end

  private

  def purge_file
    @file = ActiveStorage::Attachment.find(params[:file_id])

    if can?(:manage, @file.record)
      @file.purge
      flash[:notice] = 'File successfully deleted'
    else
      flash[:alert] = 'You are not a author!'
    end
  end
end
