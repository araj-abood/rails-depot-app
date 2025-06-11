require "test_helper"

def new_product(image_url)
  Product.new(title: "My book Title", description: "yyy", price: 1, image_url: image_url)
end

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "Product attributes must not be empty" do
    product = Product.new
    assert product.invalid?

    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "Product price must be positive" do
    product = Product.new(title: "Test product",
                          image_url: "abc.jpg",
                          description: "Lorem Ipsum")

    product.price = -1
    assert product.invalid?
    assert_equal [ "must be greater than or equal to 0.1" ], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal [ "must be greater than or equal to 0.1" ], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test "Image url valid" do
    ok = %w[fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg https://a.b.c/fred.gif]
    bad = %w[fred.doc fred.more]

    ok.each do |url|
      product = new_product url
      assert product.valid?, "#{url}, must be valid"
    end

    bad.each do |url|
      product = new_product url
      assert product.invalid?, "#{url}, must be invalid"
    end
  end

  test "Product not valid without unique title" do
    product = Product.new(title: products(:one).title, image_url: "Abcd.png", description: "abc", price: 12)
    assert product.invalid?
    assert_equal [ "has already been taken" ], product.errors[:title]
  end

  test "Product not valid if title less than 10 words" do
    product = Product.new(title: "Abc", image_url: "abcd.png", description: "abc", price: 10)
    assert product.invalid?
    assert_equal [ "Title must be atleast 10 words long" ], product.errors[:title]

    product.title = "I am a 10 words title i should work"
    assert product.valid?
  end
end
