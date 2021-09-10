module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_vote, only: [:vote, :cancel_vote]
  end

  def vote
    if !@vote
      @vote = Vote.new(vote_params)
      @vote.update(voteable_id: @resource.id, author: current_user)
      
      respond_to do |format|
        if current_user.author_of? @resource
          format.json do
            render json: @vote.errors.full_messages, status: :unprocessable_entity
          end
        elsif @vote.save
          format.json { render json: @vote }
        end
      end
    else
      @vote.update(liked: vote_params[:liked])

      respond_to do |format|
        if @vote.save
          format.json { render json: @vote }
        else
          format.json do
            render json: @vote.errors.full_messages, status: :unprocessable_entity
          end
        end
      end
    end
  end

  def cancel_vote
    respond_to do |format|
      if !@vote.nil? && current_user.author_of?(@vote)
        format.json { render json: @vote, vote_count: @resource.total_votes }
        @vote.destroy
      else
        format.json do
          render json: @vote.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def find_resource
    @resource = vote_params[:voteable_type].constantize.find(vote_params[:id])
  end

  def find_vote
    find_resource
    @vote = @resource.vote_from current_user
  end

  def vote_params
    params.permit(:id, :liked, :voteable_type)
  end
end
