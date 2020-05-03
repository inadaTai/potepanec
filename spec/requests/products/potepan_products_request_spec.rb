require 'rails_helper'

RSpec.describe "商品(product)に関するrequestテスト", type: :request do
  describe "GET /potepan/products/showに関するテスト" do
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
  end
end
