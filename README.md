# Ruby Pix - Abstração Ruby para API PIX

## Objetivo

Facilitar o processo de implantação do Pix em projetos com Ruby.

**Gem ainda em desenvolvimento**

<!-- ## Instalação

Adicione no seu Gemfile:

```ruby
gem 'pix'
```

Eexecute:

    $ bundle install

Ou instale você mesmo:

    $ gem install pix -->

## Uso

### Criando [Cobrança Imediata](https://bacen.github.io/pix-api/index.html#/Cob)

```ruby
cobranca = Pix::Cobranca.new(
    expiracao: 3600, # em segundos
    loc_id: 123, # identificador da cobranca
    devedor_cpf: '123.456.789-09',
    devedor_nome: 'Francisco da Silva',
    valor_original: 10.6,
    chave_pix: '5f84a4c5-c5cb-4599-9f13-7eb4d419dacc',
    solicitacao_pagador: 'Cobrança dos serviços prestados.'
)

# Exporta hash (JSON) no formato padrao BACEN
cobranca.json #=> Hash 
```

### Criando [Cobrança com Vencimento](https://bacen.github.io/pix-api/index.html#/Cobv)

```ruby
cobranca = Pix::Cobranca.new(
    data_vencimento: Date.new(2022, 1, 31),
    validade_apos_vencimento: 30, # em dias
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
    desconto_valor: 2.5,
    chave_pix: '5f84a4c5-c5cb-4599-9f13-7eb4d419dacc',
    solicitacao_pagador: 'Cobrança dos serviços prestados.'
)

# Exporta hash (JSON) no formato padrao BACEN
cobranca.json #=> Hash 
```

### Criando [Cobrança com multiplos Vencimentos](https://bacen.github.io/pix-api/index.html#/Cobv)

```ruby
cobranca = Pix::Cobranca.new(
    data_vencimento: Date.new(2022, 1, 31),
    validade_apos_vencimento: 30, # em dias
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
    juros_valor: 2.0,
    desconto_modalidade: 1,
    chave_pix: '5f84a4c5-c5cb-4599-9f13-7eb4d419dacc',
    solicitacao_pagador: 'Cobrança dos serviços prestados.'
)

# Valor Fixo até as datas informadas
cobranca.juros_modalidade = 1

# Desconto de R$ 10,00 até 01/02/2022
cobranca.add_desconto_data_fixa(Date.new(2022, 2, 1), 10.0)

# Desconto de R$ 5,00 até 10/02/2022
cobranca.add_desconto_data_fixa(Date.new(2022, 2, 10), 5.0)

# Exporta hash (JSON) no formato padrao BACEN
cobranca.json #=> Hash 
```

<!-- ## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Wilfison/pix. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Wilfison/pix/blob/master/CODE_OF_CONDUCT.md). -->


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

<!-- ## Code of Conduct

Everyone interacting in the Pix project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Wilfison/pix/blob/master/CODE_OF_CONDUCT.md). -->
