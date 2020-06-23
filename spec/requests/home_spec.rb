require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /potepan" do
    let!(:old_product) { create(:product, name: "old_Bags", available_on: 5.year.ago) }
    let!(:new_product) { create(:product, name: "Bags1", available_on: 1.year.ago) }
    let!(:new_product2) { create(:product, name: "Bags2", available_on: 1.year.ago) }
    let!(:new_product3) { create(:product, name: "Bags3",  available_on: 1.year.ago) }
    let!(:new_product4) { create(:product, name: "Bags4",  available_on: 1.year.ago) }
    let!(:hot_taxon) do
      create(:taxon, name: "Game", meta_keywords: "popularity",
                     icon: File.new("#{Rails.root}/spec/files/test.png"))
    end
    let!(:no_hot_taxon) { create(:taxon, name: "no_hot_Bags", meta_keywords: "Bag") }

    before do
      get potepan_root_path
    end

    it "potepan_root_pathにアクセス可能" do
      expect(response).to have_http_status(:success)
    end

    it "人気カテゴリーのみが表示されている" do
      expect(response.body).to include hot_taxon.name
      expect(response.body).to include "test.png"
      expect(response.body).not_to include no_hot_taxon.name
    end

    it "新着の商品は4件まで表示し古い商品は表示されない" do
      expect(response.body).to include new_product.name
      expect(response.body).to include new_product2.name
      expect(response.body).to include new_product3.name
      expect(response.body).to include new_product4.name
      expect(response.body).not_to include old_product.name
    end
  end
end
