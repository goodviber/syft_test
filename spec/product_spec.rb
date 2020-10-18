require 'spec_helper'

describe Product do
  subject { Product.new('001', 'surf board', 9.25) }

  it 'should return correct product code' do
    expect(subject.code).to eq('001')
  end

  it 'should return correct product name' do
    expect(subject.name).to eq('surf board')
  end

  it 'should return correct price' do
    expect(subject.price).to eq(9.25)
  end

end