require 'rails_helper'

RSpec.feature "Potepan::ProductsController", type: :feature do
  describe "Products Controllerに関するテスト" do
    let!(:taxonomy) { create(:taxonomy, name: "categories") }
    let!(:taxon) { create(:taxon, name: "Mugs", taxonomy: taxonomy) }
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00", taxons: [taxon]) }

    before do
      visit potepan_product_path product.id
    end

    it "商品詳細ページにアクセスし品名、価格と詳細が出ているかテスト" do
      expect(page).to have_title "#{product.name} - BIGBAG Store"
      expect(page).to have_content product.name
      expect(page).to have_content product.display_price
      expect(page).to have_content product.description
    end

    it "カートへ入れた際に買い物カゴ(cart_page)へアクセスできてるかテスト" do
      click_on "カートへ入れる"
      expect(page).to have_current_path potepan_cart_page_path
      expect(page).to have_title "Cart Page - BIGBAG Store"
    end
  end
end
