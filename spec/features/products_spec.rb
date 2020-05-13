require 'rails_helper'

RSpec.describe "Products", type: :feature do
  describe "商品詳細ページに関するテスト" do
    let!(:taxonomy) { create(:taxonomy, name: "Categories") }
    let!(:taxon) { create(:taxon, name: "Mugs", taxonomy: taxonomy, parent_id: taxonomy.root.id) }
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00", taxons: [taxon]) }
    let!(:related_product) { create(:product, name: "Mugmug1", price: "11.00", taxons: [taxon]) }
    let!(:related_product2) { create(:product, name: "Mugcup2", price: "12.00", taxons: [taxon]) }
    let!(:related_product3) { create(:product, name: "Mugcup3", price: "13.00", taxons: [taxon]) }
    let!(:related_product4) { create(:product, name: "Mugcup4", price: "14.00", taxons: [taxon]) }
    let!(:related_product5) { create(:product, name: "Mugcup5", price: "15.00", taxons: [taxon]) }
    let!(:other_product) do
      create(:product, name: "Mug_cup_nil", price: "11.00", tax_category_id: nil)
    end

    before do
      visit potepan_product_path product.id
    end

    it "商品詳細ページにアクセスし品名、価格と詳細が出ている" do
      expect(page).to have_title "#{product.name} - BIGBAG Store"
      expect(page).to have_content product.name
      expect(page).to have_content product.display_price
      expect(page).to have_content product.description
    end

    it "関連商品の表示数は4つまで表示で尚且つ現在表示中の商品以外の関連商品の品名、価格が出ている" do
      within "#product-list" do
        expect(page).to have_content related_product.name
        expect(page).to have_content related_product.display_price
        expect(page).to have_content related_product2.name
        expect(page).to have_content related_product2.display_price
        expect(page).to have_content related_product3.name
        expect(page).to have_content related_product3.display_price
        expect(page).to have_content related_product4.name
        expect(page).to have_content related_product4.display_price
        expect(page).not_to have_content related_product5.name
        expect(page).not_to have_content related_product5.display_price
        expect(page).not_to have_content product.display_price
        expect(page).not_to have_content product.description
      end
    end

    it "カートへ入れた際に買い物カゴのページにアクセスする" do
      click_on "カートへ入れる"
      expect(page).to have_current_path potepan_cart_page_path
      expect(page).to have_title "Cart Page - BIGBAG Store"
    end

    it "一覧ページへ戻るをクリックした際、カテゴリーページにアクセスする" do
      click_on "一覧ページへ戻る"
      expect(page).to have_current_path potepan_category_path product.taxons.first.id
    end

    it "カテゴリ商品名が紐づいてない商品はTOPへ戻るリンクが表示されクリックした際はTOPへアクセスする" do
      visit potepan_product_path other_product.id
      expect(page).to have_current_path potepan_product_path other_product.id
      expect(page).not_to have_link "一覧ページへ戻る"
      expect(page).to have_link "TOPへ戻る"
      click_on "TOPへ戻る"
      expect(page).to have_current_path potepan_path
    end
  end
end
