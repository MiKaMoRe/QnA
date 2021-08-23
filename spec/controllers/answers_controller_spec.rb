# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:post_create) { post :create, params: { answer: answer_params, question_id: question.id }, format: :js }

    context 'when authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        let(:answer_params) { attributes_for(:answer) }

        it 'saves a new answer in database' do
          expect { post_create }.to change(Answer, :count).by(1)
        end

        it 'render create view' do
          post_create
          expect(response).to render_template :create
          expect(response).to have_http_status(200)
        end
      end

      context 'with invalid attributes' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not save the answer' do
          expect { post_create }.not_to change(Answer, :count)
        end

        it 'render create view' do
          post_create
          expect(response).to render_template :create
        end
      end
    end

    context 'when unauthenticated user' do
      let(:answer_params) { attributes_for(:answer) }

      it 'not saves a new answer in database' do
        expect { post_create }.not_to change(Answer, :count)
      end

      it 'redirect to sign in' do
        post_create
        expect(response).to redirect_to "#{new_user_session_path}.js"
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: answer } }

    context 'when authenticated user' do
      let(:user) { create(:user) }
      let!(:answer) { create(:answer, author: user) }

      before { login(user) }

      it 'deletes the answer' do
        expect { delete_destroy }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete_destroy
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'when unauthenticated user' do
      let!(:answer) { create(:answer) }

      it 'not deletes the answer' do
        expect { delete_destroy }.not_to change(Answer, :count)
      end

      it 'redirect to sign in' do
        delete_destroy
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(302)
      end
    end
  end
end
