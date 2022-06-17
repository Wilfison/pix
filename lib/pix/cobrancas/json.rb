# frozen_string_literal: true

require_relative '../helpers'

module Pix
  module Cobrancas
    # Formata JSON cobranca para o padrao BACEN
    module Json
      include Helpers

      # @return [Hash] Retorna Hash formatada no padrao Bacen (pag ou pagv)
      def json
        data = {}
        load_json_calendario(data)
        load_json_location(data)
        load_json_devedor(data)
        load_json_valor(data)

        data['chave'] = chave_pix
        data['solicitacaoPagador'] = truncate(solicitacao_pagador, 140) if solicitacao_pagador
        data
      end

      private

      def load_json_calendario(data)
        calendario = {}

        if cobranca_com_vencimento?
          calendario['dataDeVencimento'] = formata_data(data_vencimento)
          calendario['validadeAposVencimento'] = validade_apos_vencimento || 30
        else
          calendario['expiracao'] = expiracao || 86_400
        end

        data['calendario'] = calendario
      end

      def load_json_location(data)
        return unless loc_id

        data['loc'] = {}
        data['loc']['id'] = loc_id
      end

      def load_json_devedor(data)
        devedor = {}
        devedor['nome'] = devedor_nome
        devedor['cpf'] = devedor_cpf if devedor_cpf
        devedor['cnpj'] = devedor_cnpj if devedor_cnpj

        if cobranca_com_vencimento?
          devedor['cep'] = sanitize_documento(devedor_cep) if devedor_cep
          devedor['uf'] = devedor_uf if devedor_uf
          devedor['cidade'] = devedor_cidade if devedor_cidade
          devedor['logradouro'] = devedor_logradouro if devedor_logradouro
        end

        data['devedor'] = devedor
      end

      def load_modificador_valor(json_valor, modificador)
        modificador_valor = send("#{modificador}_valor")

        return if modificador_valor.nil? || modificador_valor.zero?

        json_valor[modificador] = {}
        json_valor[modificador]['modalidade'] = send("#{modificador}_modalidade").to_s
        json_valor[modificador]['valorPerc'] = formata_valor("#{modificador}_valor".to_sym)
      end

      def load_desconto(json_valor)
        return unless desconto_valor || descontos

        desconto = {}
        desconto['modalidade'] = desconto_modalidade
        desconto['descontoDataFixa'] = descontos.map(&:serialize) if descontos
        desconto['valorPerc'] = formata_valor(:desconto_valor) unless descontos

        json_valor['desconto'] = desconto
      end

      def load_json_valor(data)
        valor = {}
        valor['original'] = formata_valor(:valor_original)

        if cobranca_com_vencimento?
          load_modificador_valor(valor, 'multa')
          load_modificador_valor(valor, 'juros')
          load_modificador_valor(valor, 'abatimento')
          load_desconto(valor)
        end

        data['valor'] = valor
      end
    end
  end
end
