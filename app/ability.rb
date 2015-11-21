# Users abilities
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :update, User, id: user.id
      can [:update, :delete], [Post, Comment], user_id: user.id
      can :create, [Post, Comment] unless user.new?
    end
  end
end
