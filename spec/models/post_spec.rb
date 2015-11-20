require File.expand_path('../../spec_helper.rb', __FILE__)

describe Post do
  describe 'validations' do
    it { is_expected.to validate_presence :user }
    it { is_expected.to validate_presence :body }
    it { is_expected.to validate_presence :created_at }
    it { is_expected.to validate_presence :updated_at }

    it { is_expected.to have_many_to_one :user }
  end
end
