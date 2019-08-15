class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string       :name,             default: ''
      t.boolean      :sold_out,         default: false
      t.string       :category
      t.boolean      :under_sale,       default: false
      t.integer      :price,            default: 0
      t.integer      :sale_price,       default: 0
      t.string       :sale_text,        default: ''

      t.timestamps
    end
  end
end
