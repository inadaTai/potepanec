require 'rails_helper'

RSpec.describe 'Orders', type: :feature do
  describe 'カートに関するテスト' do
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
      allow_any_instance_of(Potepan::CheckoutController).to receive_messages(current_store: store)
      variant.stock_items.first.set_count_on_hand(9)
      new_variant.stock_items.first.set_count_on_hand(9)
    end

    it "カートへ入れた際に買い物カゴのページにアクセスし商品がカート内へある状態" do
      visit potepan_product_path product.id
      select variant.options_text, from: "variant_id"
      quantity = 5
      select quantity, from: "quantity"
      click_button "カートへ入れる"
      product_total = Spree::Money.parse(product.price * quantity)
      expect(page).to have_select("order_line_items_attributes_0_quantity",
                                  selected: quantity.to_s,
                                  options: variant.selectable_quantity.map(&:to_s))
      expect(page).to have_content product_total
    end

    it "カートに入れている商品の個数を変更できる" do
      visit potepan_product_path product.id
      select variant.options_text, from: "variant_id"
      quantity = 2
      select quantity, from: "quantity"
      click_button "カートへ入れる"
      expect(page).to have_select("order_line_items_attributes_0_quantity",
                                  selected: quantity.to_s,
                                  options: variant.selectable_quantity.map(&:to_s))
      change_quantity = 4
      select change_quantity.to_s, from: "order_line_items_attributes_0_quantity"
      click_button "アップデート"
      expect(page).to have_content Spree::Money.parse(product.price * change_quantity)
    end
  end
end
