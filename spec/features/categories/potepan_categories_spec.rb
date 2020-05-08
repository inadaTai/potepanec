require 'rails_helper'

RSpec.describe "Potepan::CategoriesController", type: :feature do
  describe "Potepan CategoriesControllerに関するテスト" do
    let!(:taxonomy) { create(:taxonomy, name: "categories") }
    let!(:taxon) { create(:taxon, name: "Mugs", taxonomy: taxonomy) }
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00", taxons: [taxon]) }
    let!(:other_product) do
      create(:product, name: "Mug_cup_nil", price: "11.00", tax_category_id: nil)
    end

    before do
      visit potepan_category_path taxon.id
    end

    it "カテゴリーページにアクセスしカテゴリ名(taxonomy)とカテゴリ商品名(taxon)が出ているかテスト" do
      expect(page).to have_title "#{taxon.name} - BIGBAG Store"
      expect(page).to have_content taxonomy.name
      expect(page).to have_content taxon.name
    end

    it "商品をクリックした時に商品の詳細ページにアクセスできているか確認のテスト" do
      click_on "Mug_cup"
      expect(page).to have_current_path potepan_product_path product.id
      expect(page).to have_content product.name
      expect(page).to have_content product.display_price
      expect(page).to have_content product.description
    end

    it "商品の詳細ページから一覧ページへアクセスできているか確認のテスト" do
      click_on "Mug_cup"
      expect(page).to have_current_path potepan_product_path product.id
      click_on "一覧ページへ戻る"
      expect(page).to have_current_path potepan_category_path product.taxons.first.id
    end

    it "taxonが紐づいてない商品の詳細ページから一覧ページのリンクは表示されていないか確認のテスト" do
      visit potepan_product_path other_product.id
      expect(page).to have_current_path potepan_product_path other_product.id
      expect(page).not_to have_link "一覧ページへ戻る"
    end
  end
end
