require File.expand_path('../../spec_helper.rb', __FILE__)

describe Post do
  describe 'validations' do
    it { is_expected.to validate_presence :user }
    it { is_expected.to validate_presence :body }
    it { is_expected.to validate_presence :created_at }
    it { is_expected.to validate_presence :updated_at }

    it { is_expected.to have_many_to_one :user }
    it { is_expected.to have_one_to_many :comments }

    describe '#body_preview' do
      let(:body) { 'aaa' }
      subject { post.body_preview }

      context 'when body longer than PREVIEW_LENGTH' do
        let(:post) { build(:post, body: body * 50) }
        it { is_expected.to eq("#{post.body[0..Post::PREVIEW_LENGTH]}...") }
      end

      context 'when body length not to long' do
        let(:post) { build(:post, body: body) }
        it { is_expected.to eq(body) }
      end
    end
  end
end
