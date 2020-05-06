require 'rails_helper'

RSpec.feature "Potepan::ProductsController", type: :feature do
  describe "Products Controllerに関するテスト" do
    let!(:product) { create(:product) }

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
