class User < ApplicationRecord
    mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable, omniauth_providers: [:twitter]

  validates :accepted, presence: {message: '利用規約・プライバシーポリシーに同意してください'}

  validates :username,
            uniqueness: { case_sensitive: :false },
            length: { minimum: 4, maximum: 20 },
            format: { with: /\A[a-z0-9]+\z/, message: "ユーザー名は半角英数字です"}

  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :followings, through: :following_relationships

  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships


  def posts
   return Post.where(designer_id: self.id).order(created_at: :desc)
  end

  def following?(other_user)
   following_relationships.find_by(following_id: other_user.id)
  end

  def follow!(other_user)
   following_relationships.create!(following_id: other_user.id)
  end

  def unfollow!(other_user)
   following_relationships.find_by(following_id: other_user.id).destroy
  end

  def self.from_omniauth(auth)
       find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |user|
       user.provider = auth["provider"]
       user.uid = auth["uid"]
       user.username = auth["info"]["nickname"]
     end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
       new(session["devise.user_attributes"]) do |user|
        user.attributes = params
       end
   else
       super
   end
  end


end
