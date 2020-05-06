require 'rails_helper'

RSpec.describe "Potepan::ProductsController", type: :request do
  describe "GET /potepan/products/${product_id}" do
    let!(:product) { create(:product) }

    before do
      get potepan_product_path product.id
    end

    it "詳細ページにアクセスができているか確認のテスト" do
      expect(response).to have_http_status(:success)
    end

    it "商品(product)のデータが表示されている" do
      expect(response.body).to include product.name
    end

    describe "GET /potepan/cart_page" do
      it "カートページへアクセスできる確認のテスト" do
        get potepan_cart_page_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
