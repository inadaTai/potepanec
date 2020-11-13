module OrderWalkthrough
  def OrderWalkthrough_up_to(state)
    # Need to create a valid zone too...
    @state = FactoryBot.create(:state, country_iso: "JP")
    @country = @state.country
    @zone = create(:zone, countries: [@country])
    @payment_method = FactoryBot.create(:payment_method)
    @store = FactoryBot.create(:store)

    # A shipping method must exist for rates to be displayed on checkout page
    FactoryBot.create(:shipping_method, zones: [@zone]).tap do |sm|
      sm.calculator.preferred_amount = 10
      sm.calculator.preferred_currency = Spree::Config[:currency]
      sm.calculator.save
    end
    order = Spree::Order.create!(
      email: "spree@example.com",
      store: @store
    )
    add_line_item!(order)
    order.next!
    states_to_process = if state == :complete
                          states
                        else
                          end_state_position = states.index(state.to_sym)
                          states[0..end_state_position]
                        end
    states_to_process.each do |state_to_process|
      send(state_to_process, order)
    end
    order
  end

  private

  def add_line_item!(order)
    FactoryBot.create(:line_item, order: order)
    order.reload
  end

  def address(order)
    order.bill_address = FactoryBot.create(:address, country: @country, state: @state)
    order.ship_address = FactoryBot.create(:address, country: @country, state: @state)
    order.next!
  end

  def delivery(order)
    order.next!
  end

  def payment(order)
    credit_card = FactoryBot.create(:credit_card)
    order.payments.create!(
      payment_method: credit_card.payment_method, amount: order.total, source: credit_card
    )
    order.payment_state = 'paid'
    order.next!
  end

  def confirm(order)
    order.complete!
  end

  def complete(order)
    # noop?
  end

  def states
    [:address, :delivery, :payment, :confirm]
  end
end