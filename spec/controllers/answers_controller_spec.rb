require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id, author_id: user.id  } }.to change(Answer, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id } }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
