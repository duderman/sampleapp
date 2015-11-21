require 'spec_helper'

describe 'Profile', type: :api do
  let(:user) { create(:user) }

  describe 'GET /posts' do
    context 'when there are no posts' do
      before { get '/v1/posts' }
      it 'renders empty posts array' do
        expect(last_response.status).to eq(200)
        expect(json[:posts]).to be_empty
      end
    end

    context 'when there are some posts' do
      let(:posts_count) { 5 }
      let!(:posts) do
        create_list(:post, posts_count - 1).append(
          # To ensure that sorting working correctly
          create(:post, created_at: 1.day.ago)
        )
      end
      before { get '/v1/posts' }
      it 'renders all posts reverse ordered by created_at' do
        expect(last_response.status).to eq(200)
        posts.sort_by(&:created_at).reverse.each_with_index do |post, i|
          expect(json[:posts][i]).to eq(
            id: post.id,
            author: {
              id: post.user.id,
              email: post.user.email,
              name: post.user.name,
              is_admin: post.user.is_admin,
              created_at: post.user.created_at.as_json,
              updated_at: post.user.updated_at.as_json
            },
            body: post.body_preview,
            created_at: post.created_at.as_json,
            updated_at: post.updated_at.as_json,
            comments_count: post.comments.count
          )
        end
      end

      context 'when there are too many posts' do
        let(:posts_count) { 35 }
        it 'paginates posts by 30 per page' do
          expect(last_response.status).to eq(200)
          expect(json[:posts].count).to eq(30)
          get '/v1/posts?page=2'
          @json = nil
          expect(last_response.status).to eq(200)
          expect(json[:posts].count).to eq(5)
        end
      end
    end
  end

  describe 'GET /posts/:id' do
    subject { last_response }
    before { get "/v1/posts/#{id}" }
    context 'when there are no post with that id' do
      let(:id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2e4a' }
      it 'renders error' do
        expect(last_response.status).to eq(404)
        expect(json[:status]).to eq('error')
        expect(json[:message]).to eq(I18n.t('api.errors.not_found'))
      end
    end

    context 'when id has wrong format' do
      let(:id) { '666' }
      it 'renders error' do
        expect(last_response.status).to eq(500)
        expect(json[:status]).to eq('error')
        expect(json[:message]).to match(I18n.t('api.errors.wrong_uuid_format'))
      end
    end

    context 'when there is post with such id' do
      let(:post) do
        post = create(:post_with_comments)
        # To ensure that sorting working
        create(:comment, post: post, created_at: 1.day.ago)
        post.reload
      end
      let(:id) { post.id }

      it 'renders that post with full body and ordered comments' do
        expect(last_response.status).to eq(200)
        expect(json[:post][:id]).to eq(post.id)
        expect(json[:post][:body]).to eq(post.body)
        expect(json[:post][:comments].length).to eq(post.comments.count)
        post.comments.sort_by(&:created_at).reverse.each_with_index do |comm, i|
          expect(json[:post][:comments][i]).to eq(
            id: comm.id,
            author: {
              id: comm.user.id,
              email: comm.user.email,
              name: comm.user.name,
              is_admin: comm.user.is_admin,
              created_at: comm.user.created_at.as_json,
              updated_at: comm.user.updated_at.as_json
            },
            text: comm.text,
            created_at: comm.created_at.as_json,
            updated_at: comm.updated_at.as_json
          )
        end
      end
    end
  end

  describe 'POST /posts' do
    subject { last_response }

    context 'when not authenticated' do
      before do
        post '/v1/posts'
      end

      its(:status) { is_expected.to eq(401) }
    end

    context 'when authenticated' do
      before do
        authenticate_user user
        post '/v1/posts', params.to_json, 'CONTENT_TYPE' => 'application/json'
      end

      context 'without body' do
        let(:params) { {} }

        it 'renders error' do
          expect(last_response.status).to eq(500)
          expect(json[:status]).to eq('error')
          expect(json[:message]).to match(/body is missing/)
        end
      end

      context 'with body' do
        let(:body) { 'asdasdas' }
        let(:params) { { body: body } }

        it 'creates new record and renders new post in response' do
          expect(last_response.status).to eq(201)
          expect(Post.count).to eq(1)
          expect(Post.last.body).to eq(body)
          expect(json[:post][:body]).to eq(body)
        end
      end
    end
  end

  describe 'PUT /posts/:id' do
    subject { last_response }

    context 'when not authenticated' do
      before do
        put '/v1/posts/123'
      end

      its(:status) { is_expected.to eq(401) }
    end

    context 'when authenticated' do
      let(:params) { {} }
      before do
        authenticate_user user
        put "/v1/posts/#{id}",
          params.to_json,
          'CONTENT_TYPE' => 'application/json'
      end

      context 'and post exist' do
        let(:id) { post.id }

        context 'and post belongs to user' do
          let(:post) { create(:post, user: user) }

          context 'and body present' do
            let(:body) { 'asddas' }
            let(:params) { { body: body } }

            it 'updates body and renders updated post' do
              expect(last_response.status).to eq(200)
              expect(post.reload.body).to eq(body)
              expect(json[:post][:id]).to eq(post.id)
              expect(json[:post][:body]).to eq(body)
            end
          end

          context 'but no body present' do
            let(:params) { {} }

            it 'renders error' do
              expect(last_response.status).to eq(500)
              expect(json[:status]).to eq('error')
              expect(json[:message]).to match(/body is missing/)
            end
          end
        end

        context 'but post belongs to different user' do
          let(:post) { create(:post) }
          let(:params) { { body: 'asdsa' } }

          it 'renders error' do
            expect(last_response.status).to eq(403)
            expect(json[:status]).to eq('error')
            expect(json[:message]).to match(
              I18n.t('api.errors.you_dont_have_access')
            )
          end
        end
      end

      context 'but post do not exist' do
        let(:id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2e4a' }
        let(:params) { { body: 'asdsa' } }

        it 'renders error' do
          expect(last_response.status).to eq(404)
          expect(json[:status]).to eq('error')
          expect(json[:message]).to eq(I18n.t('api.errors.not_found'))
        end
      end

      context 'but id has wrong format' do
        let(:id) { '666' }
        let(:params) { { body: 'asdsa' } }

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

  describe 'DELETE /posts/:id' do
    subject { last_response }

    context 'when not authenticated' do
      before do
        delete '/v1/posts/123'
      end

      its(:status) { is_expected.to eq(401) }
    end

    context 'when authenticated' do
      let(:params) { {} }
      before do
        authenticate_user user
        delete "/v1/posts/#{id}",
          params.to_json,
          'CONTENT_TYPE' => 'application/json'
      end

      context 'and post exist' do
        let(:id) { post.id }

        context 'and post belongs to user' do
          let(:post) { create(:post, user: user) }

          it 'deletes post and renders message that deletion succeeded' do
            expect(last_response.status).to eq(200)
            expect(json).to eq(
              status: 'ok', message: I18n.t('api.messages.deleted')
            )
          end
        end

        context 'but post belongs to different user' do
          let(:post) { create(:post) }

          it 'renders error' do
            expect(last_response.status).to eq(403)
            expect(json[:status]).to eq('error')
            expect(json[:message]).to match(
              I18n.t('api.errors.you_dont_have_access')
            )
          end
        end
      end

      context 'but post do not exist' do
        let(:id) { '4bc94e56-ff6c-4f3c-a867-08a19e5f2e4a' }

        it 'renders error' do
          expect(last_response.status).to eq(404)
          expect(json[:status]).to eq('error')
          expect(json[:message]).to eq(I18n.t('api.errors.not_found'))
        end
      end

      context 'but id has wrong format' do
        let(:id) { '666' }

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
