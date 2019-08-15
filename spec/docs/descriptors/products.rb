require 'dox'

module Docs
  module Products
    extend Dox::DSL::Syntax

    document :api do
      resource 'Products' do
        endpoint '/products'
        group 'Products'
      end
    end

    document :index do
      action 'Get products' do
        path '/products{?q,sort,page}'
        verb 'GET'
        params ({
          q: {
            type: :object,
            required: :optional,
            properties: {
              category_in: { type: :array   },
              price_gteq:  { type: :integer },
              price_lteq:  { type: :integer }
            },
            description: 'products filter param'
          },
          sort: {
            type: :object,
            required: :optional,
            properties: {
              price: { type: :asc_or_desc_string }
            },
            description: 'products sort param'
          },
          page: {
            type: :integer,
            required: :optional,
            value: 1,
            description: 'products pagination param'
          }
        })
      end
    end

    document :show do
      action 'Get product details' do
        path '/product{?id}'
        verb 'GET'
        params ({
          id: {
            type: :integer,
            required: :required,
            value: 1328,
            description: 'product id'
          }
        })
        desc 'Get product'
      end
    end
  end
end