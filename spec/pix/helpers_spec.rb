# frozen_string_literal: true

require 'spec_helper'
require 'date'

class DummyHelperClass
  include Pix::Helpers

  attr_accessor :valor
end

RSpec.describe Pix::Helpers do
  describe '#formata_data' do
    before do
      @helper = DummyHelperClass.new
    end

    it 'format date correctly' do
      expect(@helper.formata_data(Date.new(2022, 1, 13))).to eq('2022-01-13')
    end

    it 'format date with error' do
      expect { @helper.formata_data('2022-01-13') }.to raise_error(Pix::Error, '2022-01-13 precisa ser do tipo Date')
    end
  end

  describe '#formata_valor_float' do
    before do
      @helper = DummyHelperClass.new
    end

    it 'format correctly' do
      result_normal = @helper.formata_valor_float(100.3, :valor, Pix::Cobranca)
      result_with_round = @helper.formata_valor_float(100.367, :valor, Pix::Cobranca)

      expect(result_normal).to eq('100.30')
      expect(result_with_round).to eq('100.37')
    end

    it 'format with error' do
      expect do
        @helper.formata_valor_float(100, :valor, Pix::Cobranca)
      end.to raise_error('Pix::Cobranca#valor: Deve ser um Float')
    end
  end

  describe '#formata_valor' do
    before do
      @helper = DummyHelperClass.new
    end

    it 'format correctly' do
      @helper.valor = 100.367

      expect(@helper.formata_valor(:valor)).to eq('100.37')
    end

    it 'format with error' do
      @helper.valor = 100

      expect { @helper.formata_valor(:valor) }.to raise_error('DummyHelperClass#valor: Deve ser um Float')
    end
  end

  describe '#sanitize_documento' do
    before do
      @helper = DummyHelperClass.new
    end

    it 'format correctly' do
      expect(@helper.sanitize_documento('682.688.510-74')).to eq('68268851074')
      expect(@helper.sanitize_documento('53.642.938/0001-71')).to eq('53642938000171')
    end
  end
end
