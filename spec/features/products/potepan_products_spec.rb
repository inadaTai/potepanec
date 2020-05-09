require 'rails_helper'

RSpec.describe "Potepan products", type: :feature do
  describe "商品詳細ページに関するテスト" do
    let!(:taxonomy) { create(:taxonomy, name: "categories") }
    let!(:taxon) { create(:taxon, name: "Mugs", taxonomy: taxonomy) }
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00", taxons: [taxon]) }
    let!(:other_product) do
      create(:product, name: "Mug_cup_nil", price: "11.00", tax_category_id: nil)
    end

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

    it "一覧ページへ戻るをクリックした際、カテゴリーページにアクセスできてるかテスト" do
      click_on "一覧ページへ戻る"
      expect(page).to have_current_path potepan_category_path product.taxons.first.id
    end

    it "taxonが紐づいてない商品はTOPへ戻るリンクが表示され尚且つTOPへ戻れるか確認のテスト" do
      visit potepan_product_path other_product.id
      expect(page).to have_current_path potepan_product_path other_product.id
      expect(page).not_to have_link "一覧ページへ戻る"
      expect(page).to have_link "TOPへ戻る"
      click_on "TOPへ戻る"
      expect(page).to have_current_path potepan_path
    end
  end
end
