require 'rails_helper'

RSpec.feature "サイトのレイアウトに関するテスト", type: :feature do
  describe "ルートパス（potepan_path）に関するテスト" do
    it "potepan_pathのタイトル確認" do
      visit potepan_path
      expect(page).to have_title 'BIGBAG Store'
    end
  end
end
