require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:post_create) {  post :create, params: { answer: answer_params, question_id: question.id } }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        let(:answer_params) { attributes_for(:answer) }

        it 'saves a new answer in database' do
          expect { post_create }.to change(Answer, :count).by(1)
        end

        it 'redirect to show view' do
          post_create
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not save the answer' do
          expect { post_create }.to_not change(Answer, :count)
        end

        it 're-render new view' do
          post_create
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'Unauthenticated user' do
      let(:answer_params) { attributes_for(:answer) }

      it 'not saves a new answer in database' do
        expect { post_create }.to change(Answer, :count).by(0)
      end

      it 'redirect to sign in' do
        post_create
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      let!(:answer) { create(:answer, question: question, author: user )}

      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'Unauthenticated user' do
      let!(:answer) { create(:answer, question: question, author: user )}
  
      it 'not deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end
  
      it 'redirects to sign in' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
