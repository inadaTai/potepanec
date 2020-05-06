require 'rails_helper'

RSpec.describe "ApplicationHelper", type: :helper do
  describe "#full_titleメソッドに関するテスト" do
    it "ページタイトルが空欄の時テスト" do
      expect(helper.full_title(' ')).to eq('BIGBAG Store')
    end

    it "ページタイトルがnilの時テスト" do
      expect(helper.full_title(nil)).to eq('BIGBAG Store')
    end

    it "ページタイトルが入っている時のテスト" do
      expect(helper.full_title('Test')).to eq('Test - BIGBAG Store')
    end
  end
end
