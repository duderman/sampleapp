require File.expand_path('../../spec_helper.rb', __FILE__)

describe User do
  describe 'validations' do
    it { is_expected.to validate_presence :email }
    it { is_expected.to validate_presence :name }
    it { is_expected.to validate_presence :password_digest }
    it { is_expected.to validate_presence :created_at }
    it { is_expected.to validate_presence :updated_at }

    it { is_expected.to validate_unique :email }
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
