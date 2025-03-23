# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Post
    can :read, Comment
    can :read, Podcast
    can :read, Issue
    can :create, Subscription

    return unless user.present?
    can :read, Podcast
    can :read, Issue
    can :manage, Comment, user: user

    if user.persisted? 
      can :create, Like 
      can :create, Dislike 
      can :like, Post
      can :like, Comment   
      can :dislike, Post
      can :dislike, Comment   
      can :like, Issue   
      can :dislike, Issue
    end
    
    return unless user.admin? 
    can :manage, :all
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
