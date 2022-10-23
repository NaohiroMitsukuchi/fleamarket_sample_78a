# fleamarket_sample_78a_データベース設計

## usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|email|string|null: false, unique: true|
|password|string|null: false|
|password_confirmation|string|null: false|
### Association
- has_many :items, dependent: :destroy
- has_one :profile, dependent: :destroy
- has_one :destination, dependent: :destroy
- has_one :credit_card, dependent: :destroy
- has_many :favorites, dependent: :destroy

## profilesテーブル
|Column|Type|Options|
|------|----|-------|
|first_name|string|null: false|
|family_name|string|null: false|
|first_name_kana|string|null: false|
|family_name_kana|string|null: false|
|birth_date|date|null: false|
|user|references|null: false, foreign_key: true|
### Association
- belongs_to :user

## destinationsテーブル
|Column|Type|Options|
|------|----|-------|
|first_name|string|null: false|
|family_name|string|null: false|
|first_name_kana|string|null: false|
|family_name_kana|string|null: false|
|postal_code|string|null: false|
|prefecture_code|integer|null: false|
|city|string|null: false|
|house_number|string|null: false|
|room_number|string||
|phone_number|string|null: false|
|user|references|null: false, foreign_key: true|
### Association
- belongs_to :user

## credit_cardsテーブル
|Column|Type|Options|
|------|----|-------|
|card_id|string|null: false|
|customer_id|string|null: false|
|user|references|null: false, foreign_key: true|
### Association
- belongs_to :user

## favoritesテーブル
|Column|Type|Options|
|------|----|-------|
|user|references|null: false, foreign_key: true|
|item|references|null: false, foreign_key: true|
### Association
- belongs_to :item
- belongs_to :user

## itemsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|introduction|text|null: false|
|price|integer|null: false|
|category|references|null: false, foreign_key: true|
|size|references|foreign_key: true|
|brand|references|foreign_key: true|
|item_condition|integer|null: false|
|postage_payer|integer|null: false|
|prefecture_code|integer|null: false|
|preparation_day|integer|null: false|
|status|integer|null: false|
|user|references|null: false, foreign_key: true|
### Association
- has_many :images, dependent: :destroy
- belongs_to :category
- belongs_to :size, optional: true
- belongs_to :brand, optional: true
- belongs_to_active_hash :item_condition
- belongs_to_active_hash :potage_payer
- belongs_to_active_hash :preparation_day
- belongs_to_active_hash :status
- belongs_to :user
- has_many :favorites, dependent: :destroy

## item_imagesテーブル
|Column|Type|Options|
|------|----|-------|
|url|text|null: false|
|item|references|null: false, foreign_key: true|
### Association
- belongs_to :item

## categoriesテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string|null: false|
### Association
- has_many :items
- has_many :categories_sizes
- has_many :sizes, through: :categories_sizes

## categories_sizesテーブル
|Column|Type|Options|
|------|----|-------|
|category|references|null: false, foreign_key: true|
|size|references|null: false, foreign_key: true|
### Association
- belongs_to :category
- belongs_to :size

## sizesテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string|null: false|
### Association
- has_many :items
- has_many :categories_sizes
- has_many :categories, through: :categories_sizes

## brandsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
### Association
- has_many :items