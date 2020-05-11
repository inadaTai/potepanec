require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /potepan/products/${product_id}" do
    let!(:taxonomy) { create(:taxonomy, name: "Categories") }
    let!(:taxon) { create(:taxon, name: "Mugs", taxonomy: taxonomy, parent_id: taxonomy.root.id) }
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00", taxons: [taxon]) }

    before do
      get potepan_product_path product.id
    end

    it "商品詳細ページにアクセス可能" do
      expect(response).to have_http_status(:success)
    end

    it "商品のデータが表示されている" do
      expect(response.body).to include product.name
    end

    describe "GET /potepan/cart_page" do
      it "カートページへアクセス可能" do
        get potepan_cart_page_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
