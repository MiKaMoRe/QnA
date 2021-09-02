# frozen_string_literal: true

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to :question }
  it { is_expected.to belong_to :author }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it 'have one attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#new_best_answer' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    before { answer.choose_as_best }

    it { expect(answer.best).to be_truthy }
    it { expect(best_answer.reload.best).to be_falsey }
  end
end
