module Potepan::ProductDecorator
  MAX_SEARCH_PRODUCT_DISPLAY = 9

  def self.prepended(base)
    base.scope :filter_by_taxon, ->(taxon) do
      taxon_ids = taxon.self_and_descendants.ids
      joins(:taxons).includes(master: [:default_price, :images]).
        where("#{Spree::Taxon.table_name}.id IN (?)", taxon_ids)
    end

    base.scope :filter_by_option_value, ->(option_value) do
      joins(variants: :option_values).
        where("#{Spree::OptionValue.table_name}.presentation = ?", option_value).
        group(:id)
    end

    base.scope :new_products,    -> { order(available_on: :desc) }
    base.scope :old_products,    -> { order(available_on: :asc) }
    base.scope :sort_by_order,   -> (sort) do
      case sort
      when "NEW_PRODUCTS"
        reorder(nil).new_products
      when "OLD_PRODUCTS"
        reorder(nil).old_products
      when "LOW_PRICE"
        unscope(:order).ascend_by_master_price
      when "HIGH_PRICE"
        unscope(:order).descend_by_master_price
        end
    end

    base.scope :with_images_and_prices, -> { includes(master: [:images, :default_price]) }

    base.scope :words_search, ->(words) do
      return [] if words.blank?
      regexp = "%#{words.strip.gsub(/[ 　\t]+/, "%")}%"
      products = []
      products << where("name LIKE :this OR description LIKE :this", this: regexp).with_images_and_prices
      regexp_words = words.split(/[ 　\t]/).map { |a| "%#{a.strip}%" }.each do |word|
        return if products.length > MAX_SEARCH_PRODUCT_DISPLAY
        limit_number = MAX_SEARCH_PRODUCT_DISPLAY - products.length.to_i
        exclusion_ids = products.flatten.map(&:id).uniq
        products << where("name LIKE :this OR description LIKE :this", this: word).where.not(id: exclusion_ids).limit(limit_number).with_images_and_prices
      end
      products.flatten
    end
  end

  Spree::Product.prepend self
end
