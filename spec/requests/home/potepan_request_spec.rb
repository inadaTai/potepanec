require 'rails_helper'

RSpec.describe "HOMEに関するrequestテスト", type: :request do
  describe "GET /potepan" do
    it "ルートパスへアクセス可能テスト" do
      get potepan_path
      expect(response).to have_http_status(:success)
    end
  end
end
