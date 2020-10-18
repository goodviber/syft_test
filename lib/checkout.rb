# frozen_string_literal: true

class Checkout
  attr_reader :promo_rules, :discount_manager
  attr_accessor :basket

  def initialize(promo_rules = [])
    @discount_manager = DiscountManager.new(promo_rules)
    @promo_rules = promo_rules
    @basket = []
  end

  def scan(item)
    basket << item
  end

  def total
    price = 0
    basket.each do |product|
      price += discount_manager.discount_price_for(product, quantity_in_basket(product.code))
    end
    discount_manager.discount_total(price).round(2)
  end

  private

  def quantity_in_basket(code)
    quantity = 0
    basket.each do |product|
      quantity += 1 if product.code == code
    end
    quantity
  end
end
