require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question), author: user } }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question), author: user  }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do 
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid), author: user  } }.to_not change(Question, :count)
      end
      
      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid), author: user  }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: user )}

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to root_path
    end
  end
end
