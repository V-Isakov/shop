class ProductsController < ApplicationController

  def index
    products = Product.ransack(filter_params).result
                      .order(sort_params)
                      .page(params[:page]).per(5)
    render json:  { products: products,
                    search: search_params(products) }
  end

  def show
    product = Product.where(id: params[:id]).first
    if product.present?
      render json: product
    else
      render json: { message: 'Not Found' }, status: 404
    end
  end

  private

  def search_params(products)
    { categories:  Product.categories,
      max_price:   Product.maximum(:price),
      total_pages: products.total_pages }
  end

  def filter_params
    params.require(:q).permit(:price_gteq, :price_lteq, category_in: []) if params[:q].present?
  end

  def sort_params
    params.require(:sort).permit(:price).to_h if params[:sort].present?
  end
end
