class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])

    if can?(:manage, @link.linkable)
      @link.destroy
      flash[:notice] = 'Link successfully deleted'
    else
      flash[:alert] = 'You are not a author!'
    end
  end
end
