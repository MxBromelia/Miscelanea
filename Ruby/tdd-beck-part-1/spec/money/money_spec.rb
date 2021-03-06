# frozen_string_literal: true

require 'money/money'
require 'money/bank'

describe Money do
  describe '#sum(+)' do
    it 'soma os dois escalares se a moeda é do mesmo tipo' do
      bank = Bank.new
      bank.add_rate 'USD', 'USD', 1
      expect(bank.reduce(Money.dollar(5) + Money.dollar(5), 'USD')).to eq(Money.dollar(10))
    end

    it 'soma duas moedas de tipo diferente' do
      sum = Money.dollar(5) + Money.dollar(5)
      bank = Bank.new
      bank.add_rate 'USD', 'USD', 1
      reduced = bank.reduce(sum, 'USD')
      expect(reduced).to eq(Money.dollar(10))
    end

    it 'test plus returns sum' do
      sum = Money.dollar(5) + Money.dollar(5)
      expect(sum.augend).to eq(Money.dollar(5))
      expect(sum.addend).to eq(Money.dollar(5))
    end

    it 'test reduce sum' do
      sum = Sum.new(Money.dollar(3), Money.dollar(4))
      bank = Bank.new
      bank.add_rate 'USD', 'USD', 1
      result = bank.reduce(sum, 'USD')
      expect(Money.dollar(7)).to eq(result)
    end

    it 'test reduce money' do
      bank = Bank.new
      bank.add_rate('USD', 'USD', 1)
      result = bank.reduce(Money.dollar(1), 'USD')
      expect(Money.dollar(1)).to eq(result)
    end

    it 'test reduce money different currrency' do
      bank = Bank.new
      bank.add_rate('CHF', 'USD', 2)
      result = bank.reduce(Money.franc(2), 'USD')
      expect(Money.dollar(1)).to eq(result)
    end

    it 'test mixed addition' do
      five_dollars = Money.dollar(5)
      ten_francs = Money.franc(10)
      bank = Bank.new
      bank.add_rate 'CHF', 'USD', 2
      bank.add_rate 'USD', 'USD', 1
      result = bank.reduce(five_dollars + ten_francs, 'USD')
      expect(Money.dollar(10)).to eq(result)
    end

    it 'test sum plus money' do
      five_dollars = Money.dollar(5)
      ten_francs = Money.franc(10)
      bank = Bank.new
      bank.add_rate 'CHF', 'USD', 2
      bank.add_rate 'USD', 'USD', 1
      sum = Sum.new(five_dollars, ten_francs) + five_dollars
      result = bank.reduce(sum, 'USD')
      expect(Money.dollar(15)).to eq(result)
    end

    it 'test sum times' do
      five_dollars = Money.dollar(5)
      ten_francs = Money.franc(10)
      bank = Bank.new
      bank.add_rate 'CHF', 'USD', 2
      bank.add_rate 'USD', 'USD', 1
      sum = Sum.new(five_dollars, ten_francs) * 2
      result = bank.reduce(sum, 'USD')
      expect(Money.dollar(20)).to eq(result)
    end
  end

  describe '#product(*)' do
    it 'mutiplica os escalares e retorna um objeto com o produto como valor' do
      expect(Money.dollar(5) * 3).to eq(Money.dollar(15))
    end
  end

  describe '#equality(==)' do
    it 'comparar valores se moeda é a mesma' do
      expect(Money.franc(5)).to eq(Money.franc(5))
      expect(Money.dollar(5)).to_not eq(Money.dollar(6))
    end

    it 'comparar valores com peso se moeda é outra' do
      expect(Money.franc(5)).to_not eq(Money.dollar(5))
    end
  end

  describe '#currency' do
    it 'comparara a igualdade do tipo de moeda' do
      expect(Money.franc(5).currency).to eq('CHF')
      expect(Money.dollar(5).currency).to eq('USD')
    end
  end
end
