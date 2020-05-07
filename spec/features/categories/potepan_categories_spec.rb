require 'rails_helper'

RSpec.describe "Potepan::CategoriesController", type: :feature do
  describe "Potepan::CategoriesControllerに関するテスト" do
    let!(:taxonomy) { create(:taxonomy, name: "categories") }
    let!(:taxon) { create(:taxon, name: "Mugs", taxonomy: taxonomy) }
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00", taxons: [taxon]) }

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
  end
end
