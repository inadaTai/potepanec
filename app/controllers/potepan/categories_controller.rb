class Potepan::CategoriesController < ApplicationController
  def show
    @taxonomies = Spree::Taxonomy.includes(:root)
    @taxon = Spree::Taxon.find(params[:id])
    @taxon_products = @taxon.all_products.includes(master: [:default_price, :images])
  end
end
