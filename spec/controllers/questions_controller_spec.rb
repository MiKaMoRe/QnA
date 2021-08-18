require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:post_create) { post :create, params: { question: question_params } }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        let(:question_params) { attributes_for(:question) }

        it 'saves a new question in the database' do
          expect { post_create }.to change(Question, :count).by(1)
        end

        it 'redirect to show view' do
          post_create
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do 
        let(:question_params) { attributes_for(:question, :invalid) }

        it 'does not save the question' do
          expect { post_create }.to_not change(Question, :count)
        end
        
        it 're-render new view' do
          post_create
          expect(response).to render_template :new
        end
      end
    end

    context 'Unauthenticated user' do
      let(:question_params) { attributes_for(:question) }

      it 'saves a new question in the database' do
        expect { post_create }.to_not change(Question, :count)
      end

      it 'redirect to sign in' do
        post_create
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      let!(:question) { create(:question, author: user )}

      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end

    context 'Unauthenticated user' do
      let!(:question) { create(:question, author: user) }
      
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
  
      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
