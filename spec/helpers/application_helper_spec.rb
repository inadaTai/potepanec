require 'rails_helper'

RSpec.describe "ApplicationHelper", type: :helper do
  describe "#full_titleメソッドに関するテスト" do
    subject { helper.full_title(title) }

    context "ページタイトルが空欄の時の表示" do
      let(:title) { ' ' }

      it { is_expected.to eq 'BIGBAG Store' }
    end

    context "ページタイトルがnilの時の表示" do
      let(:title) { nil }

      it { is_expected.to eq 'BIGBAG Store' }
    end

    context "ページタイトルが入っている時の表示" do
      let(:title) { 'Test' }

      it { is_expected.to eq 'Test - BIGBAG Store' }
    end
  end
end
