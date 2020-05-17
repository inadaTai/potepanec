class Potepan::HomeController < ApplicationController
  MAX_NEW_PRODUCTS = 4
  MAX_HOT_TAXONS = 3
  #新着商品はnew_productsメソッドにてdescで管理しています。
  #メタキーワードにpopularityと入れてる商品は人気カテゴリーに出ます。
  def index
    @new_products = Spree::Product.new_products.limit(MAX_NEW_PRODUCTS)
    @hot_taxons = Spree::Taxon.where("meta_keywords=?", "popularity").limit(MAX_HOT_TAXONS)
  end
end
