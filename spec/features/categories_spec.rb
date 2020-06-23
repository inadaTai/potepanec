require 'rails_helper'

RSpec.describe "Categories", type: :feature do
  describe "カテゴリページに関するテスト" do
    let!(:taxonomy) { create(:taxonomy, name: "Categories") }
    let!(:taxon) { create(:taxon, name: "Mugs", taxonomy: taxonomy, parent_id: taxonomy.root.id) }
    let!(:taxon2) { create(:taxon, name: "Bags", taxonomy: taxonomy, parent_id: taxonomy.root.id) }
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00", variants: [red_and_small_variant], available_on: 1.year.ago, taxons: [taxon]) }
    let!(:option_color) { create(:option_type, presentation: "Color") }
    let!(:old_product) do
      create(:product, name: "Old_cup", price: "11.00", variants: [other_variant], available_on: 5.year.ago,
                       taxons: [taxon])
    end
    let!(:product2) do
      create(:product, name: "Rubybag", price: "11.00", variants: [other_variant], taxons: [taxon2])
    end
    let!(:value_color) do
      create(:option_value, name: "Red", presentation: "Red", option_type: option_color)
    end
    let!(:value_size) do
      create(:option_value, name: "Small", presentation: "S", option_type: option_size)
    end
    let!(:option_size) { create(:option_type, presentation: "Size") }
    let(:red_and_small_variant) do
      create(:variant, option_values: [value_color, value_size])
    end
    let(:other_variant) do
      create(:variant, option_values: [value_color, value_size])
    end

    before do
      visit potepan_category_path taxon.id
    end

    it "カテゴリーページにアクセスしカテゴリ名とカテゴリ商品名が出ている" do
      expect(page).to have_title "#{taxon.name} - BIGBAG Store"
      within "#category-list" do
        expect(page).to have_content taxonomy.name
        expect(page).to have_content "Mugs(2)"
        expect(page).to have_content "Bags(1)"
      end
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

    it "色指定した場合の表示確認" do
      within find('a', text: 'Red') do
        expect(page).to have_selector 'span', text: "(1)"
      end
      click_link "Red"
      expect(page).to have_content product.name
      expect(page).not_to have_content product2.name
    end

    it "サイズ指定した場合の表示確認" do
      within "#size-list" do
        within find('a', text: 'S') do
          expect(page).to have_selector 'span', text: "(1)"
        end
        click_link "S"
      end
      expect(page).to have_content product.name
      expect(page).not_to have_content product2.name
    end

    it "商品表示の変更を確認" do
      within "#guiest_id1" do
        expect(page).to have_content "新着順"
        expect(page).to have_content "安い順"
        expect(page).to have_content "高い順"
        expect(page).to have_content "古い順"
      end
    end

    it "新着順に並べ替えた場合" do
      visit "/potepan/categories/#{taxon.id}?sort=NEW_PRODUCTS"
      within first('.productBox') do
        expect(page).to have_selector 'h5', text: "#{product.name}"
      end
    end

    it "古い順に並べ替えた場合" do
      visit "/potepan/categories/#{taxon.id}?sort=OLD_PRODUCTS"
      within first('.productBox') do
        expect(page).to have_selector 'h5', text: "#{old_product.name}"
      end
    end

    it "値段が高い順に並べ替えた場合" do
      visit "/potepan/categories/#{taxon.id}?sort=HIGH_PRICE"
      within first('.productBox') do
        expect(page).to have_selector 'h5', text: "#{old_product.name}"
      end
    end

    it "安い順に並べ替えた場合" do
      visit "/potepan/categories/#{taxon.id}?sort=LOW_PRICE"
      within first('.productBox') do
        expect(page).to have_selector 'h5', text: "#{product.name}"
      end
    end
  end
end
