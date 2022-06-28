# frozen_string_literal: true

require './spec/spec_helper'
require './lib/pix/cobrancas/json/bradesco'

RSpec.describe Pix::Cobrancas::Json::Bradesco do
  describe 'gera json' do
    let(:cobranca) do
      Pix::Cobranca.new(
        expiracao: 3600,
        loc_id: 123,
        devedor_logradouro: 'Alameda Souza, Numero 80, Bairro Braz',
        devedor_cidade: 'Recife',
        devedor_uf: 'PE',
        devedor_cep: '70011750',
        devedor_cpf: '123.456.789-09',
        devedor_cnpj: '53.642.938/0001-71',
        devedor_nome: 'Francisco da Silva',
        valor_original: 10.6,
        multa_modalidade: 1,
        multa_valor: 5.1,
        juros_modalidade: 2,
        juros_valor: 2.0,
        desconto_modalidade: 1,
        chave_pix: '5f84a4c5-c5cb-4599-9f13-7eb4d419dacc',
        solicitacao_pagador: 'Cobrança dos serviços prestados.'
      )
    end

    it 'valida schema' do
      json = described_class.new(cobranca).json

      expect(json).to include('calendario')
      expect(json).to include('devedor')
      expect(json).to include('valor')
      expect(json).to include('chave_pix')
      expect(json).to include('solicitacaopagador')
      expect(json).to_not include('loc')
    end

    it 'location.id not presente' do
      location = described_class.new(cobranca).json

      expect(location['loc']).to be_nil
    end

    context 'cobranca imediata' do
      it 'calendario (cobranca imediata) presente' do
        calendario = described_class.new(cobranca).json['calendario']

        expect(calendario['expiracao']).to eq(3600)
        expect(calendario['dataDeVencimento']).to be_nil
        expect(calendario['validadeAposVencimento']).to be_nil
      end

      it 'devedor dados presente' do
        devedor = described_class.new(cobranca).json['devedor']

        expect(devedor['cpf']).to eq('12345678909')
        expect(devedor['cnpj']).to be_nil
        expect(devedor['nome']).to eq('Francisco da Silva')
        expect(devedor['logradouro']).to be_nil
        expect(devedor['cidade']).to be_nil
        expect(devedor['uf']).to be_nil
        expect(devedor['cep']).to be_nil
      end

      it 'dados de valor presente' do
        json = described_class.new(cobranca).json['valor']

        expect(json).to include('original')
        expect(json).to_not include('multa')
        expect(json).to_not include('juros')
        expect(json).to_not include('desconto')
      end
    end

    context 'cobranca com vencimento' do
      before do
        cobranca.data_vencimento = Date.new(2022, 1, 31)
        cobranca.validade_apos_vencimento = 30
      end

      it 'calendario (cobranca com vencimento) presente' do
        cobranca.validade_apos_vencimento = 30
        calendario = described_class.new(cobranca).json['calendario']

        expect(calendario['expiracao']).to be_nil
        expect(calendario['dataDeVencimento']).to eq('2022-01-31')
        expect(calendario['validadeAposVencimento']).to eq(30)
      end

      it 'devedor dados presente' do
        cobranca.devedor_cpf = nil
        devedor = described_class.new(cobranca).json['devedor']

        expect(devedor['cpf']).to be_nil
        expect(devedor['cnpj']).to eq('53642938000171')
        expect(devedor['nome']).to eq('Francisco da Silva')
        expect(devedor['logradouro']).to eq('Alameda Souza, Numero 80, Bairro Braz')
        expect(devedor['cidade']).to eq('Recife')
        expect(devedor['uf']).to eq('PE')
        expect(devedor['cep']).to eq('70011750')
      end

      it 'dados de valor.multa presente' do
        json = described_class.new(cobranca).json['valor']

        expect(json['multa']['modalidade']).to eq('1')
        expect(json['multa']['valorPerc']).to eq('5.10')
      end

      it 'dados de valor.juros presente' do
        json = described_class.new(cobranca).json['valor']

        expect(json['juros']['modalidade']).to eq('2')
        expect(json['juros']['valorPerc']).to eq('2.00')
      end

      it 'dados de valor.desconto simples presente' do
        cobranca.desconto_valor = 2.0
        json = described_class.new(cobranca).json['valor']

        expect(json['desconto']['modalidade']).to eq('1')
        expect(json['desconto']['valorPerc']).to eq('2.00')
      end

      it 'dados de valor.desconto composto presente' do
        cobranca.add_desconto_data_fixa(Date.new(2022, 2, 1), 10.3)

        json = described_class.new(cobranca).json['valor']
        json_desconto = json['desconto']['descontoDataFixa']

        expect(json['desconto']['modalidade']).to eq('1')
        expect(json['desconto']['valorPerc']).to be_nil

        expect(json_desconto).to be_a(Array)
        expect(json_desconto[0]).to include('data')
        expect(json_desconto[0]).to include('valorPerc')
        expect(json_desconto[0]['data']).to eq('2022-02-01')
        expect(json_desconto[0]['valorPerc']).to eq('10.30')
      end

      it 'informacoes adicionais' do
        cobranca.add_info_adicional('item adicional', 'valor adicional')

        json = described_class.new(cobranca).json['info_adicionais']

        expect(json).to be_a(Array)
        expect(json[0]).to include('nome')
        expect(json[0]).to include('valor')
        expect(json[0]['nome']).to eq('item adicional')
        expect(json[0]['valor']).to eq('valor adicional')
      end
    end
  end
end
