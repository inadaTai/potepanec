require 'rails_helper'

RSpec.describe "Potepan::HomeController", type: :request do
  describe "GET /potepan" do
    it "potepan_pathへアクセス可能テスト" do
      get potepan_path
      expect(response).to have_http_status(:success)
    end
  end
end
