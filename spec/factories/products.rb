FactoryBot.define do
  factory :book, class: Product do
    name       Faker::Book.title
    sold_out   false
    category   'Book'
    under_sale false
    sequence(:price) { |n| n * 1000 }
    sale_price 0
    sale_text  ''
  end

  factory :food, class: Product do
    name       Faker::Food.dish
    sold_out   false
    category   'Food'
    under_sale false
    sequence(:price) { |n| n * 100 }
    sale_price 0
    sale_text  ''
  end
end