require 'spec_helper'

describe ProductsController, api: true, type: :controller do
  include Docs::Products::Api

  before :each do
    request.headers.merge!({ 'Accept' => 'application/json' })
  end

  let!(:products) { create_list(:book, 6) + create_list(:food, 6) }

  describe "GET #index" do
    include Docs::Products::Index

    context "without params" do

      it 'sends a list of products', :dox do
        get :index

        expect(response).to be_success
        expect(hash_body['products'].count).to match(5)
      end

      it 'sends search params' do
        get :index

        expect(hash_body['search']).to have_key('categories')
        expect(hash_body['search']).to have_key('max_price')
        expect(hash_body['search']).to have_key('total_pages')
      end
    end

    context "with filter params" do

      it 'filters products by category', :dox do
        get :index, params: { q: { category_in: ['Food'] }}

        expect(response).to be_success
        expect(hash_body['products'].map{ |h| h['category'] }.uniq).to eq(['Food'])
      end

      it 'filters products by price', :dox do
        get :index, params: { q: { price_gteq:  1000,
                                   price_lteq:  3000 }}

        expect(response).to be_success
        expect(hash_body['products'].sample['price']).to be_between(1000, 3000)
      end
    end

    context "with sort params" do

      it 'sorts products by price asc', :dox do
        get :index, params: { sort: { price: :asc }}

        expect(response).to be_success
        expect(hash_body['products'][0]['price']).to be < hash_body['products'][1]['price']
      end

      it 'sorts products by price desc' do
        get :index, params: { sort: { price: :desc }}

        expect(response).to be_success
        expect(hash_body['products'][0]['price']).to be > hash_body['products'][1]['price']
      end
    end

    context "with pagination params" do
      it 'paginates products', :dox do
        get :index, params: { page: 3 }

        expect(response).to be_success
        expect(hash_body['products'].count).to eq(2)
      end
    end
  end

  describe "GET #show" do
    include Docs::Products::Show

    it 'sends a product details', :dox do
      get :show, params: { id: products.first.id }

      expect(response).to be_success
      expect(hash_body['id']).to eq(products.first.id)
    end

    it 'sends an error message', :dox do
      get :show, params: { id: 0 }

      expect(response.status).to      eq(404)
      expect(hash_body['message']).to eq('Not Found')
    end
  end
end