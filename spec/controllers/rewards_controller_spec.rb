# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let!(:reward) { create(:reward, user: user) }
    
    before { login(user) }

    before { get :index }

    it 'assigns a new Reward to @rewards' do
      expect(assigns(:rewards)).to match_array(user.rewards)
    end
  end
end
