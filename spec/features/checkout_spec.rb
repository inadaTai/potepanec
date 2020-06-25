require 'rails_helper'

RSpec.describe "Checkout", type: :feature do
  include ActiveJob::TestHelper

  context '配送範囲内からの注文の場合' do
    let(:credit_card) { create(:credit_card) }

    let!(:product) do
      create(:product, name: "Tshirt", variants: [variant], tax_category: tax_category)
    end
    let(:variant) { create(:variant) }
    let(:new_variant) { create(:variant) }
    let(:tax_category) { create(:tax_category, is_default: true) }
    let(:zone) { create(:zone, countries: [country]) }
    let(:store) { create(:store, cart_tax_country_iso: cart_tax_country_iso) }
    let!(:cart_tax_country_iso) { country.iso }
    let!(:country) { create(:country, iso: "JP") }

    before do
      @order = OrderWalkthrough_up_to(:address)
      allow_any_instance_of(Potepan::CheckoutController).to receive_messages(current_store: @store)
      variant.stock_items.first.set_count_on_hand(9)
      new_variant.stock_items.first.set_count_on_hand(9)
    end

    def addcart_product
      visit potepan_product_path product.id
      select variant.options_text, from: "variant_id"
      quantity = 1
      select quantity, from: "quantity"
      click_button "カートへ入れる"
    end

    def correct_address_form
      within ".billing_info_form" do
        fill_in '姓', with: '山田'
        fill_in '名', with: '太郎'
        fill_in 'メールアドレス', with: 'foo@bar.com'
        fill_in '電話番号', with: '000-0000-0000'
        fill_in '郵便番号', with: '000-0000'
        fill_in '市', with: '釧路市'
        fill_in '住所', with: '●●区●●町0-00'
      end
      click_button '次へ'
    end

    context "無効な情報登録を行った場合" do
      it "お届け先情報ページで無効な情報を入力した場合" do
        addcart_product
        find('#purchase').click
        expect(page).to have_link 'back'
        expect(page).to have_checked_field('請求先の情報を使う')
        within ".billing_info_form" do
          fill_in '姓', with: ''
          fill_in '名', with: ''
          fill_in 'メールアドレス', with: ''
          fill_in '電話番号', with: ''
          fill_in '郵便番号', with: ''
          fill_in '市', with: ''
          fill_in '住所', with: ''
        end
        click_button '次へ'
        expect(page).to have_content "10　個のエラーがあります。"
      end

      it "お支払い方法ページで無効な情報を入力した場合" do
        addcart_product
        find('#purchase').click
        correct_address_form
        fill_in "カード名義人", with: ""
        fill_in "カード番号", with: ""
        fill_in "セキュリティコード", with: ""
        click_button '次へ'
        expect(page).to have_content "3　個のエラーがあります。"
      end
    end

    context "有効な情報登録を行った場合" do
      it "お届け先情報ページで有効な情報を入力したらお支払いページに変遷する" do
        addcart_product
        find('#purchase').click
        correct_address_form
        expect(page).to have_content 'カード名義人'
        expect(page).to have_content 'カード番号'
        expect(page).to have_content 'セキュリティコード'
      end

      it "お支払い方法ページで有効な情報を入力したら商品購入確認ページに変遷し購入を確定する" do
        addcart_product
        find('#purchase').click
        correct_address_form
        fill_in "カード名義人", with: credit_card.name
        fill_in "カード番号", with: credit_card.number
        fill_in "セキュリティコード", with: credit_card.verification_value
        select credit_card.month, from: "payment_source[#{@payment_method.id}][expiry][value(2i)]"
        select credit_card.year, from: "payment_source[#{@payment_method.id}][expiry][value(1i)]"
        click_on "次へ"
        expect(page).to have_content '入力内容確認'
        expect(page).to have_content 'お届け先情報'
        click_link "購入確定"
        @order.reload
        expect(page).to have_content "Thank You !! ご注文ありがとうございます。"
        expect(page).to have_content 'Email:spree@example.org'
        expect(page).to have_content 'Shipping address:spree@example.org'
      end
    end
  end
end
