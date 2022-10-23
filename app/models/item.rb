class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  has_many :item_images, dependent: :destroy
  accepts_nested_attributes_for :item_images, allow_destroy: true
  validates_associated :item_images

  belongs_to :category
  belongs_to :size, optional: true
  belongs_to :brand, optional: true
  belongs_to_active_hash :item_condition
  belongs_to_active_hash :postage_payer
  belongs_to_active_hash :preparation_day
  belongs_to_active_hash :status
  belongs_to :user
  has_many :favorites, dependent: :destroy

  with_options presence: true do
    validates :name
    validates :introduction
    validates :price, numericality: {only_integer: true}
    validates :category_id
    validates :item_images
    validates :item_condition_id
    validates :postage_payer_id
    validates :preparation_day_id
    validates :prefecture_code
    validates :user_id
  end
end