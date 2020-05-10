require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /potepan" do
    it "potepan_pathにアクセス可能" do
      get potepan_path
      expect(response).to have_http_status(:success)
    end
  end
end
