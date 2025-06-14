class Product < ApplicationRecord
  validates :title, :description, :image_url, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.1 }
  validates :title, uniqueness: true
  validates :title, length: { minimum: 10, message: "Title must be atleast 10 words long" }
  validates :image_url, allow_blank: true, format: {
    with: %r{\.gif|jpg|png\z}i,
    message: "must be a URL for GIF, JPG or PNG image"
  }
end
