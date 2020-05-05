require 'rails_helper'

RSpec.describe "ApplicationHelperに関するhelperテスト", type: :helper do
  describe "#full_titleメソッドに関するテスト" do
    context "ページタイトルが空のとき" do
      it "ページタイトルが空欄の時テスト" do
        expect(helper.full_title(' ')).to eq('BIGBAG Store')
      end
    end

    context "ページタイトルがnilのとき" do
      it "ページタイトルがnilの時テスト" do
        expect(helper.full_title(nil)).to eq('BIGBAG Store')
      end
    end

    context "ページタイトルが入っているとき" do
      it "フルタイトルメソッドのテスト(titleはTestと代入)" do
        expect(helper.full_title('Test')).to eq('Test - BIGBAG Store')
      end
    end
  end
end
