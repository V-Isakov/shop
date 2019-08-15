class Product < ApplicationRecord
  def self.categories
    pluck(:category).uniq
  end
end
