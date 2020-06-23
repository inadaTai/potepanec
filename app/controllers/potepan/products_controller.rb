class Potepan::ProductsController < ApplicationController
  MAX_RELATED_PRODUCTS = 4

  def show
    @product = Spree::Product.find(params[:id])
    @related_products = Spree::Product.in_taxons(@product.taxons).includes(master: [:default_price, :images]).
      where.not(id: @product.id).distinct.limit(MAX_RELATED_PRODUCTS)
  end
end
