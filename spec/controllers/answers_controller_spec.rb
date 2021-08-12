require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  
  before { login(user) }

  describe 'POST #create' do
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

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, author: user )}

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(answer.question)
    end
  end
end
