class User
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps::Created

  # uncomment to enable sms messages after create musician account
  #after_create :sms_message

  searchkick word_start: [:name]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  # field :sign_in_count,      type: Integer, default: 0
  # field :current_sign_in_at, type: Time
  # field :last_sign_in_at,    type: Time
  # field :current_sign_in_ip, type: String
  # field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :role, type: String, default: 'observer'
  field :name, type: String
  field :recommendations, type: Array, default: []
  field :visited, type: Integer, default: 0
  field :fb, type: String
  field :yt, type: String
  field :ig, type: String
  field :tw, type: String
  field :online, type: Boolean, default: false

  scope :musicians, ->{where(role: "musician")}

  has_mongoid_attached_file :avatar,
    default_style: :normal,
    styles:{
      big: ['200x200#', :png],
      thumb: ['50x50#', :png],
      normal: ['100x100#', :png]
   },
   default_url: "/images/avatar_:style.png"

   has_mongoid_attached_file :background

  validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  validates_attachment :background, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  validates :name, presence: true

  has_many :musics, dependent: :destroy
  has_many :upvotes, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :give_observations, foreign_key: "observed_by_id", class_name: "Observation", dependent: :destroy
  has_many :observations, foreign_key: "being_observed_id", class_name: "Observation", dependent: :destroy
  has_many :idols, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :recipient_chats, foreign_key: "recipient_chats_id", class_name: "Chatroom", dependent: :destroy
  has_many :sender_chats, foreign_key: "sender_chats_id", class_name: "Chatroom", dependent: :destroy
  has_and_belongs_to_many :featurings, class_name: "Music", inverse_of: :features

  ROLES = %w[musician observer superadmin fame]

  FACEBOOK = "https://www.facebook.com/"
  YOUTUBE = "https://www.youtube.com/"
  INSTAGRAM = "https://www.instagram.com/"
  TWITTER = "https://twitter.com/"


  def is?(r)
    role.include?(r.to_s)
  end

  def musician?
    is?(:musician)
  end

  def observer?
    is?(:observer)
  end

  def fame?
    is?(:fame)
  end

  def superadmin?
    is?(:superadmin)
  end

  def observations_objects
    objects = []
    self.give_observations.each do |observation|
      objects += Music.where(user_id: observation.being_observed_id)
      objects += Post.where(user_id: observation.being_observed_id)
    end

    objects.sort_by! { |e| e.created_at }.reverse!
  end

  def recommendations_to_display
    display = []
    self.recommendations.uniq.each do |recommendation|
      display.push(User.find(recommendation))
    end
    display
  end

  def all_observations
    users = []
    self.give_observations.each do |observation|
      users.push(User.find(observation.being_observed_id))
    end
    users
  end

  def visited_ratio
    self.visited.to_i / (( Time.now - self.created_at) / 86400)
  end

  def self.best_by_visited_ratio
    users = User.where(role: "musician").all
    users = users.sort_by! {|x| x.visited_ratio}.reverse!
    users[0...6]
  end

  def full_fb
    FACEBOOK + self.fb
  end

  def full_yt
    YOUTUBE + self.yt
  end

  def full_ig
    INSTAGRAM + self.ig
  end

  def full_tw
    TWITTER + self.tw
  end

  def has_sm(sm)
    if sm == "" or sm == nil
      false
    else
      true
    end
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(name: data['name'],
           email: data['email'],
           avatar: open(data['image']),
           password: Devise.friendly_token.first(8),
           confirmed_at: Time.now
        )
    end
    user
  end

  def notifications_to_display
    notifications_array = []
    notifications.each do |notification|
      if notification.music.nil?
        notifications_array << notification.text
      else
        music = Music.find(notification.music)
        if notification.fame.present?
          fame = User.find(notification.fame)
          notifications_array << [fame.name + notification.text + music.title, notification]
        elsif notification.musician.present?
          mus = User.find(notification.musician)
          notifications_array << [mus.name + notification.text + music.title, notification]
        end
      end

    end
    notifications_array
  end

  def sms_message
    if self.role == 'musician'
      message = I18n.t(:sms_musician_register)
      number = I18n.t(:twilio_send_number)
      TwilioTextMessenger.new(message, number).call
    end
  end

  def is_online
    self.set(online: true)

    #to jest źle
    users = User.where(online: true).all
    users.each do |user|
      AperanceChannel.broadcast_to(
        user,
        id: "#{self.id}",
        online: self.online
      )
    end
  end

  def is_offline
    self.set(online: false)

    #to jest źle
    users = User.where(online: true).all
    users.each do |user|
      AperanceChannel.broadcast_to(
        user,
        id: "#{self.id}",
        online: self.online
      )
    end
  end

  def destroy_recommendation(current_user)

    self.recommendations.each_with_index do |recommendation, index|
      if recommendation == current_user.id
        self.recommendations.delete_at(index)
        self.save
        break
      end
    end
  end

  def add_recommendation(current_user, music)
    self.recommendations.push(current_user.id)
    self.notifications.create(text: t(:upvoted), fame: current_user.id, music: music.id)
    self.save
  end

  def increment_visited
    self.set(visited: (self.visited + 1))
  end

  def self.possible_features(current_user)
    User.musicians.to_a.reject{ |user| user==current_user}
  end

end
