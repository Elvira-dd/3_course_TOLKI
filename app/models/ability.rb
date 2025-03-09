# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Post
    can :read, Podcast
    can :read, Issue
    can :create, Subscription

    return unless user.present?
    can :read, Podcast
    can :read, Issue
    can :manage, Post, user: user
    can :manage, Comment, user: user

    if user.persisted? # Только авторизованные пользователи
      can :create, Like # Разрешаем ставить лайки
      can :like, Post   # Разрешаем действие like на постах
    end
    
    return unless user.admin? 
    can :manage, :all
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
