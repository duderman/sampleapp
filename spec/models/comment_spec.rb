require File.expand_path('../../spec_helper.rb', __FILE__)

describe Comment do
  describe 'validations' do
    it { is_expected.to validate_presence :user }
    it { is_expected.to validate_presence :post }
    it { is_expected.to validate_presence :text }
    it { is_expected.to validate_presence :created_at }
    it { is_expected.to validate_presence :updated_at }

    it { is_expected.to have_many_to_one :user }
    it { is_expected.to have_many_to_one :post }
  end
end
