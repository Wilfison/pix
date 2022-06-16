# frozen_string_literal: true

shared_examples_for 'cobrancas' do
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
      multa_modalidade: '1',
      multa_valor: 5.1,
      juros_modalidade: '2',
      juros_valor: 2.0,
      desconto_modalidade: '1',
      chave_pix: '5f84a4c5-c5cb-4599-9f13-7eb4d419dacc',
      solicitacao_pagador: 'Cobrança dos serviços prestados.'
    )
  end

  let(:cobranca_v) do
    Pix::Cobranca.new(
      data_vencimento: Date.new(2022, 1, 31),
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
      multa_modalidade: '1',
      multa_valor: 5.1,
      juros_modalidade: '2',
      juros_valor: 2.0,
      desconto_modalidade: '1',
      chave_pix: '5f84a4c5-c5cb-4599-9f13-7eb4d419dacc',
      solicitacao_pagador: 'Cobrança dos serviços prestados.'
    )
  end
end
