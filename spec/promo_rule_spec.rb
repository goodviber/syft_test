# frozen_string_literal: true

require 'spec_helper'

describe PromoRule do
  subject { PromoRule.new(PromoRule::TYPE[:discount]) }

  describe '#type' do
    it 'should return type as value' do
      expect(subject.type).to eq(1)
    end
  end

  describe '::discount_promo_rule' do
    subject { PromoRule.discount_rule(60, 10) }

    it 'should be instance of PromoRule' do
      expect(subject).to be_a_kind_of(PromoRule)
    end
  end

  describe '#apply' do
    it 'should call block with no arguments' do
      value = false
      promo_rule = PromoRule.new(PromoRule::TYPE[:discount]) do
        value = true
      end
      expect(promo_rule.apply).to be_truthy
    end

    it 'should call block with one argument' do
      promo_rule = PromoRule.new(PromoRule::TYPE[:discount]) do |value|
        value
      end
      expect(promo_rule.apply('foo')).to eq('foo')
    end

    it 'should call block with two arguments' do
      promo_rule = PromoRule.new(PromoRule::TYPE[:discount]) do |value1, value2|
        "#{value1}-#{value2}"
      end
      expect(promo_rule.apply('foo', 'bar')).to eq('foo-bar')
    end

    it 'should call block with three arguments' do
      promo_rule = PromoRule.new(PromoRule::TYPE[:discount]) do |value1, value2, value3|
        "#{value1}-#{value2}-#{value3}"
      end
      expect(promo_rule.apply('foo', 'bar', 'baz')).to eq('foo-bar-baz')
    end
  end

  describe '::multi_discount_rule' do
    subject { PromoRule.multi_discount_rule('001', 10, 5.00) }

    it 'should be instance of PromoRule' do
      expect(subject).to be_a_kind_of(PromoRule)
    end

    it 'should calculate discount when count is equal to qualifying_qualtity' do
      discount = subject.apply('001', 10)
      expect(discount).to eq(5.00)
    end

    it 'should calculate discount when count is more than qualifying_quantity' do
      discount = subject.apply('001', 11)
      expect(discount).to eq(5.00)
    end

    it 'should not discount when count is less than qualifying_qauntity' do
      discount = subject.apply('001', 9)
      expect(discount).to be_nil
    end

    it 'should not discount when product code is different' do
      discount = subject.apply('002', 10)
      expect(discount).to be_nil
    end
  end

  describe '::discount_rule' do
    subject { PromoRule.discount_rule(60, 10) }

    it 'should be instance of PromoRule' do
      expect(subject).to be_a_kind_of(PromoRule)
    end

    it 'should calculate discount when count is equal' do
      discounted = subject.apply(60.00)
      expect(discounted).to eq(54)
    end

    it 'should calculate discount when count is more than' do
      discounted = subject.apply(61.00)
      expect(discounted).to eq(54.9)
    end

    it 'should not discount when count is less than' do
      discounted = subject.apply(59.00)
      expect(discounted).to eq(59)
    end
  end
end
