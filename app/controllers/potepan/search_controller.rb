class Potepan::SearchController < ApplicationController
  def show
    @word = params[:search_word]
    @products = Spree::Product.words_search(params[:search_word])
  end
end
