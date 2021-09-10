require 'rails_helper'

describe 'voteable' do
  module Voteable; end

  context 'with question' do
    with_model :Question do
      model do
        include Voteable
      end
    end

    let(:user) { create(:user) }
    subject { Question.create }

    it { is_expected.to have_many(:votes).dependent(:destroy) }

    it "has the module" do
      expect(Question.include?(Voteable)).to eq true
    end
  end
end
