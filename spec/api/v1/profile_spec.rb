require 'spec_helper'

describe 'Profile', type: :api do
  let(:user) { create(:user) }

  describe 'GET /profile' do
    subject { last_response }

    context 'when not authenticated' do
      before do
        get '/v1/profile'
      end

      its(:status) { is_expected.to eq(401) }
    end

    context 'when authenticated' do
      before do
        authenticate_user user
        get '/v1/profile'
      end

      it 'renders user info' do
        expect(last_response.status).to eq(200)
        expect(json[:user]).to eq(
          id: user.id,
          email: user.email,
          name: user.name,
          is_admin: user.is_admin,
          created_at: user.created_at.as_json,
          updated_at: user.updated_at.as_json
        )
      end
    end
  end

  describe 'PUT /profile' do
    subject { last_response }

    context 'when not authenticated' do
      before do
        get '/v1/profile'
      end

      its(:status) { is_expected.to eq(401) }
    end

    context 'when authenticated' do
      let(:params) do
        {
          name: FFaker::Name.name,
          email: FFaker::Internet.email,
          is_admin: true
        }
      end

      before do
        authenticate_user user
        put '/v1/profile', params.to_json, 'CONTENT_TYPE' => 'application/json'
        user.reload
      end

      it 'renders new user info' do
        expect(last_response.status).to eq(200)
        expect(json[:user]).to eq(
          id: user.id,
          email: params[:email],
          name: params[:name],
          is_admin: user.is_admin,
          created_at: user.created_at.as_json,
          updated_at: user.updated_at.as_json
        )
      end

      it 'updates only allowed attribtues' do
        expect(user.is_admin).to be false
      end
    end
  end

  describe 'PUT /profile/change_password' do
    subject { last_response }

    context 'when not authenticated' do
      before do
        get '/v1/profile'
      end

      its(:status) { is_expected.to eq(401) }
    end

    context 'when authenticated' do
      let(:password) { FFaker::Internet.password }
      let(:params) do
        {
          password: password,
          confirmation: password
        }
      end

      before do
        authenticate_user user
        put '/v1/profile/change_password',
          params.to_json, 'CONTENT_TYPE' => 'application/json'
        user.reload
      end

      it 'changes user password' do
        expect(last_response.status).to eq(200)
        expect(user.authenticate(password)).to eq(user)
      end

      context 'when password and confirmation do not match' do
        let(:params) { { password: password, confirmation: 'aa' } }

        it 'renders error' do
          expect(last_response.status).to eq(422)
          expect(json[:status]).to eq('error')
          expect(json[:message]).to match(/Can't save record/)
        end
      end

      context 'when password or confirmation are not present' do
        let(:params) { {} }

        its(:status) { is_expected.to eq(500) }
        its(:body) { is_expected.to match(/password is missing/) }
        its(:body) { is_expected.to match(/confirmation is missing/) }
      end
    end
  end
end
