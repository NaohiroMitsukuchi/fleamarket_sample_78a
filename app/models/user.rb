class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nickname, presence: true
  validates :email, uniqueness: {case_sensitive: true}, format: { with: /\A([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+\z/ }
  validates :password, presence: true, length: { minimum: 7 }
  has_many :items, dependent: :destroy
  has_one :profile, dependent: :destroy, inverse_of: :user
  has_one :destination, dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :destination
  accepts_nested_attributes_for :profile
  include JpPrefecture
  jp_prefecture :prefecture_code
  has_many :items, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

end
