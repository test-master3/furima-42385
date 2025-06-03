class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :state
  belongs_to :delivery_cost
  belongs_to :prefecture
  belongs_to :delivery_date

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :image, presence: true

  belongs_to :user
  has_one :order
  has_one_attached :image

  validates :category_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :state_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :delivery_cost_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :prefecture_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :delivery_date_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :price,
            numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999,
                            message: 'は300円以上9,999,999円以下で入力してください' }
end
