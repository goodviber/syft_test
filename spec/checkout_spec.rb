# frozen_string_literal: true

require 'spec_helper'

describe Checkout do
  let(:promo_rules) do
    [
      PromoRule.discount_rule(60, 10),
      PromoRule.multi_discount_rule('001', 2, 8.50)
    ]
  end
  subject(:no_promo) { described_class.new }
  subject(:promo) { described_class.new(promo_rules) }
  let(:product1) { Product.new('001', 'Lavender Heart', 9.25) }
  let(:product2) { Product.new('002', 'Personalised cufflinks', 45.00) }
  let(:product3) { Product.new('003', 'Kids T-shirt', 19.95) }

  describe 'on setup' do
    it 'should start with an empty basket' do
      expect(subject.basket.count).to eq(0)
    end
    it 'should start with zero total price' do
      expect(subject.total).to eq(0)
    end
  end

  describe '#scan' do
    it 'should assign items to basket' do
      subject.scan(product1)
      subject.scan(product2)
      expect(subject.basket.count).to eq(2)
    end
  end

  describe '#total' do
    context 'with no promo_rules' do
      it 'should calculate undiscounted total' do
        no_promo.scan(product1)
        no_promo.scan(product2)
        no_promo.scan(product3)
        expect(no_promo.total).to eq(74.2)
      end

      it 'should round to two decimal places' do
        product = Product.new('001', 'name', 25.4552)
        no_promo.scan(product)
        expect(no_promo.total).to eq(25.46)
      end
    end
  end

  context 'with promo_rules' do
    context 'with qualifying total sum' do
      it 'should apply discount correctly' do
        promo.scan(product1)
        promo.scan(product2)
        promo.scan(product3)
        expect(promo.total).to eq(66.78)
      end
    end

    context 'with qualifying products and less than qualifying total sum' do
      it 'should apply discount correctly' do
        promo.scan(product1)
        promo.scan(product3)
        promo.scan(product1)
        expect(promo.total).to eq(36.95)
      end
    end

    context 'with qualifying products and qualifying total sum' do
      it 'should apply discount correctly' do
        promo.scan(product1)
        promo.scan(product2)
        promo.scan(product1)
        promo.scan(product3)
        expect(promo.total).to eq(73.76)
      end
    end

    it 'should round to two decimal places' do
      product = Product.new('001', 'name', 25.4552)
      promo.scan(product)
      expect(promo.total).to eq(25.46)
    end
  end
end
