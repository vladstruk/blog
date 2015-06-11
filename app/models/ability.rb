class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.moderator?
      can [:update], [Article, Comment]
      can [:destroy], [Article, Comment], user_id: user.id
    elsif user.blogger?
      can [:update], [Article, Comment], user_id: user.id
      can [:destroy], [Article, Comment], user_id: user.id
    end
  end
end
