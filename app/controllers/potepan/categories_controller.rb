class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:id])
    @search_form = ProductSearchForm.new(taxon: @taxon, color: params[:color], size: params[:size])
    @products = @search_form.search.sort_by_order(params[:sort])
    @taxonomies = Spree::Taxonomy.includes(:root)
    @option_type = Spree::OptionType.all
  end
end
