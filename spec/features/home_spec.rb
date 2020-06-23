require 'rails_helper'

RSpec.describe "Home", type: :feature do
  describe "ポテパンパスに関するテスト" do
    it "potepan_root_pathのタイトル確認" do
      visit potepan_root_path
      expect(page).to have_title 'BIGBAG Store'
    end
  end
end
