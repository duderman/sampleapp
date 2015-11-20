Sequel.seed do
  N = 3
  def run
    users = seed_users
    posts = seed_posts(users)
    seed_comments(users, posts)
  end

  private

  def seed_users
    N.times.map do
      User.create(
        email: FFaker::Internet.email,
        name: FFaker::Name.name,
        password: '12345678',
        password_confirmation: '12345678'
      )
    end
  end

  def seed_posts(users)
    users.map do |user|
      N.times.map { Post.create(user: user, body: FFaker::Lorem.paragraph) }
    end.flatten
  end

  def seed_comments(users, posts)
    posts.each do |post|
      N.times do
        Comment.create(
          post: post,
          user: users.sample,
          text: FFaker::Lorem.sentence
        )
      end
    end
  end
end
