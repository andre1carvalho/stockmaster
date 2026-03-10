class Product < ApplicationRecord
  validates :name, :category, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :name, uniqueness: { case_sensitive: false }
  validates :brand, presence: true
end
