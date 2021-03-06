class Potepan::HomeController < ApplicationController
  MAX_NEW_PRODUCTS = 4
  MAX_HOT_TAXONS = 3

  def index
    @new_products = Spree::Product.includes(master: [:default_price, :images]).
      order(available_on: "DESC").limit(MAX_NEW_PRODUCTS)
    @hot_taxons = Spree::Taxon.where("meta_keywords=?", "popularity").limit(MAX_HOT_TAXONS)
  end
end
