require File.expand_path('../../spec_helper.rb', __FILE__)

describe User do
  describe 'validations' do
    it { is_expected.to validate_presence :email }
    it { is_expected.to validate_presence :name }
    it { is_expected.to validate_presence :password_digest }
    it { is_expected.to validate_presence :created_at }
    it { is_expected.to validate_presence :updated_at }

    it { is_expected.to validate_unique :email }
    it do
      is_expected.to validate_format(
        /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
        :email
      )
    end

    it { is_expected.to have_one_to_many :posts }
  end

  describe '.authenticate' do
    subject { described_class.authenticate(email, password) }
    let(:email) { 'user@mail.com' }

    context 'when user exists' do
      let(:user_password) { 'asd' }
      let!(:user) do
        create(
          :user,
          email: email,
          password: user_password,
          password_confirmation: user_password
        )
      end

      context 'with wrong password' do
        let(:password) { 'ads' }
        it { is_expected.to be nil }
      end

      context 'with correct password' do
        let(:password) { user_password }
        it { is_expected.to eq user }
      end
    end

    context 'when user not exist' do
      let(:password) { 'asd' }
      it { is_expected.to be nil }
    end
  end

  describe '#admin?' do
    subject { user.admin? }

    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      it { is_expected.to be true }
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }
      it { is_expected.to be false }
    end

    context 'when user has no is_admin option' do
      let(:user) { create(:user, is_admin: nil) }
      it { is_expected.to be false }
    end
  end
end
