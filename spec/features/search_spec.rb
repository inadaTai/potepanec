require 'rails_helper'

RSpec.describe "Search", type: :feature do
  describe "検索バーに関するテスト" do
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00") }
    let!(:product2) { create(:product, name: "Rubybag", price: "11.00") }

    before do
      visit potepan_root_path
    end

    it "無効な検索ワードを入力した場合" do
      fill_in 'Search…', with: ''
      click_on '検索'
      expect(page).to have_content "に該当する商品が見つかりませんでした"
      expect(page).not_to have_content product.name
      expect(page).not_to have_content product.display_price
      expect(page).not_to have_content product2.name
      expect(page).not_to have_content product2.display_price
    end

    it "有効な検索ワードを入力した場合ヒットした商品が並ぶ" do
      fill_in 'Search…', with: 'bag'
      click_on '検索'
      expect(page).to have_content product2.name
      expect(page).to have_content product2.display_price
      expect(page).not_to have_content product.name
      expect(page).not_to have_content product.display_price
    end
  end
end
