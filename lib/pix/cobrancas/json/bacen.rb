# frozen_string_literal: true

require 'pix/helpers'

module Pix
  module Cobrancas
    module Json
      # Formata JSON cobranca para o padrao BACEN
      class Bacen
        include Pix::Helpers

        def initialize(cobranca)
          @cob = cobranca
        end

        # @return [Hash] Retorna Hash formatada no padrao Bacen (pag ou pagv)
        def json
          data = {}
          load_json_calendario(data)
          load_json_location(data)
          load_json_devedor(data)
          load_json_valor(data)
          load_chave_pix(data)
          load_info_adicionais(data)

          data
        end

        private

        attr_reader :cob

        def rename_item(data, old_key, new_key)
          item_value = data.delete(old_key)

          data[new_key] = item_value
        end

        def load_chave_pix(data)
          data['chave'] = cob.chave_pix
        end

        def load_solicitacao(data)
          data['solicitacaoPagador'] = truncate(cob.solicitacao_pagador, 140) if cob.solicitacao_pagador
        end

        def load_json_calendario(data)
          calendario = {}

          if cob.cobranca_com_vencimento?
            calendario['dataDeVencimento'] = formata_data(cob.data_vencimento)
            calendario['validadeAposVencimento'] = cob.validade_apos_vencimento || 30
          else
            calendario['expiracao'] = cob.expiracao || 86_400
          end

          data['calendario'] = calendario
        end

        def load_json_location(data)
          return unless cob.loc_id

          data['loc'] = {}
          data['loc']['id'] = cob.loc_id
        end

        def load_json_devedor(data)
          devedor = {}
          devedor['nome'] = cob.devedor_nome
          devedor['cpf'] = cob.devedor_cpf if cob.devedor_cpf
          devedor['cnpj'] = cob.devedor_cnpj if cob.devedor_cnpj && cob.devedor_cpf.nil?

          if cob.cobranca_com_vencimento?
            devedor['cep'] = sanitize_documento(cob.devedor_cep) if cob.devedor_cep
            devedor['uf'] = cob.devedor_uf if cob.devedor_uf
            devedor['cidade'] = cob.devedor_cidade if cob.devedor_cidade
            devedor['logradouro'] = cob.devedor_logradouro if cob.devedor_logradouro
          end

          data['devedor'] = devedor
        end

        def load_modificador_valor(json_valor, modificador)
          modificador_valor = cob.send("#{modificador}_valor")
          modificador_attr = "#{modificador}_valor".to_sym

          return if modificador_valor.nil? || modificador_valor.zero?

          json_valor[modificador] = {}
          json_valor[modificador]['modalidade'] = cob.send("#{modificador}_modalidade").to_s
          json_valor[modificador]['valorPerc'] = formata_valor_float(modificador_valor, modificador_attr, cob)
        end

        def load_desconto(json_valor)
          return unless cob.desconto_valor || cob.descontos

          desconto = {}
          desconto['modalidade'] = cob.desconto_modalidade.to_s
          desconto['descontoDataFixa'] = cob.descontos.map(&:serialize) if cob.descontos
          desconto['valorPerc'] = formata_valor_float(cob.desconto_valor, :desconto_valor, cob) unless cob.descontos

          json_valor['desconto'] = desconto
        end

        def load_json_valor(data)
          valor = {}
          valor['original'] = formata_valor_float(cob.valor_original, :valor_original, cob)

          if cob.cobranca_com_vencimento?
            load_modificador_valor(valor, 'multa')
            load_modificador_valor(valor, 'juros')
            load_modificador_valor(valor, 'abatimento')
            load_desconto(valor)
          end

          data['valor'] = valor
        end

        def load_info_adicionais(data)
          return unless cob.info_adicionais

          data['infoAdicionais'] = cob.info_adicionais.map(&:serialize)
        end
      end
    end
  end
end
