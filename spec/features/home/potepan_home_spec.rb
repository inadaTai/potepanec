require 'rails_helper'

RSpec.feature "Potepan::HomeController", type: :feature do
  describe "Home Controllerに関するテスト" do
    it "potepan_pathのタイトル確認" do
      visit potepan_path
      expect(page).to have_title 'BIGBAG Store'
    end
  end
end
