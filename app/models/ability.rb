class Ability
  include CanCan::Ability

  def initialize(model)
    # TODO: review that this works ok..
    case model
    when User
      can :manage, :all
      can :manage, Message do |message|
        message.user == User
      end
    when Admin
      can :manage, :all
    else
      can :read, :all
     end
    end
end
