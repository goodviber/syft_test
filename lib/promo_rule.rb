# frozen_string_literal: true

class PromoRule
  attr_reader :type, :block

  TYPE = { discount: 1, multi_discount: 2 }.freeze

  def initialize(type, &block)
    @type = type
    @block = block
  end

  def apply(*args)
    block.call(*args)
  end

  def self.discount_rule(minimum_spend, percentage_discount)
    PromoRule.new(PromoRule::TYPE[:discount]) do |sum_total|
      if sum_total >= minimum_spend
        sum_total -= sum_total * percentage_discount / 100
      else
        sum_total.round(2)
      end
    end
  end

  def self.multi_discount_rule(product_code, qualifying_quantity, discount_price)
    PromoRule.new(PromoRule::TYPE[:multi_discount]) do |code, quantity|
      discount_price if code == product_code && quantity >= qualifying_quantity
    end
  end
end
