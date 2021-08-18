require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:created_answers).dependent(:destroy) }
  it { should have_many(:created_questions).dependent(:destroy) }

  describe '#author_of?' do
    let(:author) { create(:user) }
    let(:resource) { create(:question, author: author) }

    context 'when user is the author' do
      it { expect(author).to be_author_of(resource) }
    end

    context 'when user is not the author' do
      let(:not_author) { create(:user) }

      it { expect(not_author).to_not be_author_of(resource) }
    end
  end
end
