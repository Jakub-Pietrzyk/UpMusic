class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      @user = user
      musician if user.musician?
      observer if user.observer?
      superadmin if user.superadmin?
      fame if user.fame?
      disable_not_allowed_actions
    end
  end

  def superadmin
    can :manage, :all
  end

  def musician
    can [:index, :create, :show, :show_by_genre, :hall_of_fame], Music
    can [:destroy, :update], Music, user_id: @user.id
    can :create, Upvote
    can :destroy, Upvote, user_id: @user.id
    can [:create, :show, :super_posts, :index], Post
    can [:destroy, :update], Post, user_id: @user.id
    can :create, Comment
    can :destroy, Comment, user_id: @user.id
    can [:update, :add_sm], User, id: @user.id
    can :show, User
    can :create, Idol
    can :destroy, Idol, user_id: @user.id
    can :change_background, User, id: @user.id
  end

  def observer
    can [:show, :index, :show_by_genre, :hall_of_fame], Music
    cannot [:create, :edit, :update, :delete], Music
    can :create, Upvote
    can :destroy, Upvote, user_id: @user.id
    can [:show, :super_posts, :index], Post
    cannot [:create, :destroy], Comment
    can :update, User, user_id: @user.id
    can :show, User
    cannot [:create, :destroy], Idol
  end

  def fame
    can [:index, :show, :show_by_genre, :hall_of_fame], Music
    can [:create, :destroy], Upvote, user_id: @user.id
    can [:show, :super_posts, :index], Post
    can [:create, :destroy], Comment, user_id: @user.id
    can :update, User, user_id: @user.id
    can :show, User
    cannot [:create, :destroy], Idol
  end

  def disable_not_allowed_actions

  end

end
