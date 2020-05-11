require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /potepan/categories/${taxon_id}" do
    let!(:taxonomy) { create(:taxonomy, name: "Categories") }
    let!(:taxon) { create(:taxon, name: "Mugs", taxonomy: taxonomy, parent_id: taxonomy.root.id) }
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00", taxons: [taxon]) }

    before do
      get potepan_category_path taxon.id
    end

    it "カテゴリーページにアクセス可能" do
      expect(response).to have_http_status(:success)
    end

    it "分類と商品のデータが表示されている" do
      expect(response.body).to include taxonomy.name
      expect(response.body).to include taxon.name
      expect(response.body).to include product.name
    end
  end
end
