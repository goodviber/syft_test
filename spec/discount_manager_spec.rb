# frozen_string_literal: true

require 'spec_helper'

describe DiscountManager do
  let(:promo_rules) do
    [
      PromoRule.discount_rule(60, 10),
      PromoRule.multi_discount_rule('001', 2, 8.50)
    ]
  end
  let(:product) { Struct.new(:code, :name, :price).new('001', 'foobar', 20) }
  subject { DiscountManager.new(promo_rules) }

  describe '#discount_price_for' do
    it 'should pass the calculation to the promo_rule with params' do
      expect(promo_rules.last).to receive(:type) { PromoRule::TYPE[:multi_discount] }
      expect(promo_rules.last).to receive(:apply).with(product.code, 2)

      subject.discount_price_for(product, 2)
    end

    it 'should return the discounted price when rule applied' do
      price = subject.discount_price_for(product, 2)
      expect(price).to eq(8.50)
    end

    it 'should return the original price if no rule applied' do
      discount_manager = DiscountManager.new

      price = discount_manager.discount_price_for(product, 1)
      expect(price).to eq(product.price)
    end
  end

  describe '#discount_total' do
    it 'should pass the calculation to the promo_rule with total' do
      expect(promo_rules.first).to receive(:type) { PromoRule::TYPE[:discount] }
      expect(promo_rules.first).to receive(:apply).with(20)

      subject.discount_total(20)
    end

    it 'should return the calculated total when rule applied' do
      total = subject.discount_total(100)
      expect(total).to eq(90)
    end

    it 'should return original subtotal if no rule match' do
      discount_manager = DiscountManager.new

      total = discount_manager.discount_total(10)
      expect(total).to eq(10)
    end
  end
end
