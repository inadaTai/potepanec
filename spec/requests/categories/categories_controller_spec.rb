require 'rails_helper'

RSpec.describe "Potepan::CategoriesController", type: :request do
  describe "GET /potepan/categories/${taxon_id}" do
    let!(:taxonomy) { create(:taxonomy, name: "categories") }
    let!(:taxon) { create(:taxon, name: "Mugs", taxonomy: taxonomy) }
    let!(:product) { create(:product, name: "Mug_cup", price: "10.00", taxons: [taxon]) }

    before do
      get potepan_category_path taxon.id
    end

    it "カテゴリーページにアクセスができているか確認のテスト" do
      expect(response).to have_http_status(:success)
    end

    it "分類(taxonomyとtaxon)のデータが表示されている" do
      expect(response.body).to include taxonomy.name
      expect(response.body).to include taxon.name
    end
  end
end
