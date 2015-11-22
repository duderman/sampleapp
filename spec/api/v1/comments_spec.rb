require 'spec_helper'

describe 'Posts API', type: :api do
  let(:user) { create(:user) }

  describe 'POST /posts/:post_id/comments' do
    subject { last_response }

    context 'when not authenticated' do
      let(:post_id) { 'asdas' }
      before do
        post "/v1/posts/#{post_id}/comments"
      end

      its(:status) { is_expected.to eq(401) }
    end

    context 'when authenticated' do
      before do
        authenticate_user user
        post "/v1/posts/#{post_id}/comments",
          params.to_json,
          'CONTENT_TYPE' => 'application/json'
      end

      context 'and post exist' do
        let(:mpost) { create(:post) }
        let(:post_id) { mpost.id }

        before { mpost.reload }

        context 'without text' do
          let(:params) { {} }

          it 'renders error' do
            expect(last_response.status).to eq(500)
            expect(json[:status]).to eq('error')
            expect(json[:message]).to match(/text is missing/)
          end
        end

        context 'with text' do
          let(:text) { 'asdasdas' }
          let(:params) { { text: text } }

          it 'creates new comment and renders success message' do
            expect(last_response.status).to eq(201)
            expect(mpost.comments.count).to eq(1)
            expect(mpost.comments.last.text).to eq(text)
            expect(json).to eq(
              status: 'ok', message: I18n.t('api.messages.created')
            )
          end
        end
      end

      context 'but post do not exist' do
        let(:post_id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2666' }
        let(:params) { { text: 'asdsa' } }

        it 'renders error' do
          expect(last_response.status).to eq(404)
          expect(json[:status]).to eq('error')
          expect(json[:message]).to eq(I18n.t('api.errors.not_found'))
        end
      end

      context 'but post_id has wrong format' do
        let(:post_id) { 'asd' }
        let(:params) { { text: 'asdsa' } }

        it 'renders error' do
          expect(last_response.status).to eq(500)
          expect(json[:status]).to eq('error')
          expect(json[:message]).to match(
            I18n.t('api.errors.wrong_uuid_format')
          )
        end
      end
    end
  end

  describe 'PUT /posts/:post_id/comments/:id' do
    subject { last_response }

    context 'when not authenticated' do
      let(:post_id) { '123' }
      let(:comment_id) { '123' }
      before do
        put "/v1/posts/#{post_id}/comments/#{comment_id}"
      end

      its(:status) { is_expected.to eq(401) }
    end

    context 'when authenticated' do
      before do
        authenticate_user user
        put "/v1/posts/#{post_id}/comments/#{comment_id}",
          params.to_json,
          'CONTENT_TYPE' => 'application/json'
      end

      context 'and post exist' do
        let(:mpost) { create(:post) }
        let(:post_id) { mpost.id }

        before { mpost.reload }

        context 'and comment exist' do
          let(:comment_id) { comment.id }
          before { comment.reload }

          context 'and comment belongs to current user' do
            let(:comment) { create(:comment, post: mpost, user: user) }

            context 'without text' do
              let(:params) { {} }

              it 'renders error' do
                expect(last_response.status).to eq(500)
                expect(json[:status]).to eq('error')
                expect(json[:message]).to match(/text is missing/)
              end
            end

            context 'with text' do
              let(:text) { 'asdasdas' }
              let(:params) { { text: text } }

              it 'updates that comment and renders success message' do
                expect(last_response.status).to eq(200)
                expect(mpost.comments.count).to eq(1)
                expect(mpost.comments.last.text).to eq(text)
                expect(json).to eq(
                  status: 'ok', message: I18n.t('api.messages.updated')
                )
              end
            end
          end

          context 'but comment belongs to different user' do
            let(:comment) { create(:comment, post: mpost) }
            let(:params) { { text: 'adsa' } }

            it 'renders error' do
              expect(last_response.status).to eq(403)
              expect(json[:status]).to eq('error')
              expect(json[:message]).to match(
                I18n.t('api.errors.you_dont_have_access')
              )
            end
          end
        end

        context 'but comment do not exist' do
          let(:post_id) { mpost.id }
          let(:comment_id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2666' }
          let(:params) { { text: 'asdsa' } }

          it 'renders error' do
            expect(last_response.status).to eq(404)
            expect(json[:status]).to eq('error')
            expect(json[:message]).to eq(I18n.t('api.errors.not_found'))
          end
        end

        context 'but id has wrong format' do
          let(:post_id) { mpost.id }
          let(:comment_id) { '123' }
          let(:params) { { text: 'asdsa' } }

          it 'renders error' do
            expect(last_response.status).to eq(500)
            expect(json[:status]).to eq('error')
            expect(json[:message]).to match(
              I18n.t('api.errors.wrong_uuid_format')
            )
          end
        end
      end

      context 'but post do not exist' do
        let(:post_id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2666' }
        let(:comment_id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2666' }
        let(:params) { { text: 'asdsa' } }

        it 'renders error' do
          expect(last_response.status).to eq(404)
          expect(json[:status]).to eq('error')
          expect(json[:message]).to eq(I18n.t('api.errors.not_found'))
        end
      end

      context 'but post_id has wrong format' do
        let(:post_id) { 'asd' }
        let(:comment_id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2666' }
        let(:params) { { text: 'asdsa' } }

        it 'renders error' do
          expect(last_response.status).to eq(500)
          expect(json[:status]).to eq('error')
          expect(json[:message]).to match(
            I18n.t('api.errors.wrong_uuid_format')
          )
        end
      end
    end
  end

  describe 'DELETE /posts/:post_id/comments/:id' do
    subject { last_response }

    context 'when not authenticated' do
      let(:post_id) { '123' }
      let(:comment_id) { '123' }
      before do
        delete "/v1/posts/#{post_id}/comments/#{comment_id}"
      end

      its(:status) { is_expected.to eq(401) }
    end

    context 'when authenticated' do
      before do
        authenticate_user user
        delete "/v1/posts/#{post_id}/comments/#{comment_id}"
      end

      context 'and post exist' do
        let(:mpost) { create(:post) }
        let(:post_id) { mpost.id }

        before { mpost.reload }

        context 'and comment exist' do
          let(:comment_id) { comment.id }

          context 'and comment belongs to current user' do
            let(:comment) { create(:comment, post: mpost, user: user) }

            it 'deletes that comment and renders success message' do
              expect(last_response.status).to eq(200)
              expect(mpost.comments.count).to be_zero
              expect(json).to eq(
                status: 'ok', message: I18n.t('api.messages.deleted')
              )
            end
          end

          context 'but comment belongs to different user' do
            let(:comment) { create(:comment, post: mpost) }

            it 'renders error' do
              expect(last_response.status).to eq(403)
              expect(json[:status]).to eq('error')
              expect(json[:message]).to match(
                I18n.t('api.errors.you_dont_have_access')
              )
            end
          end
        end

        context 'but comment do not exist' do
          let(:post_id) { mpost.id }
          let(:comment_id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2666' }

          it 'renders error' do
            expect(last_response.status).to eq(404)
            expect(json[:status]).to eq('error')
            expect(json[:message]).to eq(I18n.t('api.errors.not_found'))
          end
        end

        context 'but id has wrong format' do
          let(:post_id) { mpost.id }
          let(:comment_id) { '123' }

          it 'renders error' do
            expect(last_response.status).to eq(500)
            expect(json[:status]).to eq('error')
            expect(json[:message]).to match(
              I18n.t('api.errors.wrong_uuid_format')
            )
          end
        end
      end

      context 'but post do not exist' do
        let(:post_id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2666' }
        let(:comment_id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2666' }
        let(:params) { { text: 'asdsa' } }

        it 'renders error' do
          expect(last_response.status).to eq(404)
          expect(json[:status]).to eq('error')
          expect(json[:message]).to eq(I18n.t('api.errors.not_found'))
        end
      end

      context 'but post_id has wrong format' do
        let(:post_id) { 'asd' }
        let(:comment_id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2666' }
        let(:params) { { text: 'asdsa' } }

        it 'renders error' do
          expect(last_response.status).to eq(500)
          expect(json[:status]).to eq('error')
          expect(json[:message]).to match(
            I18n.t('api.errors.wrong_uuid_format')
          )
        end
      end
    end
  end
end
