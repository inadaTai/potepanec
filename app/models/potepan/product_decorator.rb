Spree::Product.class_eval do
  scope :related_products, -> product do
    in_taxons(product.taxons).includes(master: [:default_price, :images]).
      distinct.where.not(id: product.id)
  end

  scope :new_products, -> do
    includes(master: [:default_price, :images]).order(available_on: "ASC")
  end
end
