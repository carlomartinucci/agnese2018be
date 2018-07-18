class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.tutor?
      can :read, :all
      can :manage, Lecture, user_id: user.id
    end
  end
end
