require 'rails_helper'

RSpec.describe "Categories", type: :feature do
  describe "カテゴリページに関するテスト" do
    let!(:taxonomy) { create(:taxonomy, name: "Categories") }
    let!(:taxon) { create(:taxon, name: "Mugs", taxonomy: taxonomy) }
    let!(:taxon2) { create(:taxon, name: "Bags", taxonomy: taxonomy) }
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00", taxons: [taxon]) }
    let!(:product2) { create(:product, name: "Rubybag", price: "11.00", taxons: [taxon2]) }
    let!(:taxonomies) { taxon.move_to_child_of(taxonomy.root) }
    let!(:taxonomies2) { taxon2.move_to_child_of(taxonomy.root) }

    before do
      visit potepan_category_path taxon.id
    end

    it "カテゴリーページにアクセスしカテゴリ名とカテゴリ商品名が出ている" do
      expect(page).to have_title "#{taxon.name} - BIGBAG Store"
      expect(page).to have_content taxonomy.name
      expect(page).to have_content "Mugs(1)"
      expect(page).to have_content "Bags(1)"
    end

    it "現在のカテゴリ商品ページで他のカテゴリ商品が出ていないことを確認" do
      expect(page).to have_content "Mug_cup"
      expect(page).not_to have_content "Rubybag"
    end

    it "商品をクリックした時に商品の詳細ページにアクセス可能" do
      click_on "Mug_cup"
      expect(page).to have_current_path potepan_product_path product.id
      expect(page).to have_content product.name
      expect(page).to have_content product.display_price
      expect(page).to have_content product.description
    end
  end
end
