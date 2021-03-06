require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /potepan/products/${product_id}" do
    let!(:taxonomy) { create(:taxonomy, name: "Categories") }
    let!(:taxon) { create(:taxon, name: "Mugs", taxonomy: taxonomy, parent_id: taxonomy.root.id) }
    let!(:taxon2) { create(:taxon, name: "Bags", taxonomy: taxonomy, parent_id: taxonomy.root.id) }
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00", taxons: [taxon]) }
    let!(:related_product) { create(:product, name: "Mugcup1", price: "11.00", taxons: [taxon]) }
    let!(:unrelated_product) { create(:product, name: "Rubybag", price: "16.00", taxons: [taxon2]) }

    before do
      get potepan_product_path product.id
    end

    it "商品詳細ページにアクセス可能" do
      expect(response).to have_http_status(:success)
    end

    it "商品のデータが表示されている" do
      expect(response.body).to include product.name
    end

    it "関連商品のデータが表示されており違う関連商品のデータは表示されていない" do
      expect(response.body).to include related_product.name
      expect(response.body).not_to include unrelated_product.name
    end

    describe "GET /potepan/cart" do
      it "カートページへアクセス可能" do
        get potepan_cart_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
