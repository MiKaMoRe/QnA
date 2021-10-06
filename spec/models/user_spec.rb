# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:created_answers).dependent(:destroy) }
  it { is_expected.to have_many(:created_questions).dependent(:destroy) }
  it { is_expected.to have_many(:rewards).dependent(:destroy) }
  it { is_expected.to have_many(:subscribed_questions).through(:question_subscription).source(:question).dependent(:destroy) }

  describe '#author_of?' do
    subject(:user) { create(:user) }

    context 'when user is the author' do
      let(:resource) { create(:question, author: user) }

      it { is_expected.to be_author_of(resource) }
    end

    context 'when user is not the author' do
      let(:resource) { create(:question) }

      it { is_expected.not_to be_author_of(resource) }
    end
  end
end
