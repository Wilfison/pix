# frozen_string_literal: true

require 'securerandom'

require_relative './bacen'

module Pix
  module Cobrancas
    module Json
      # Formata JSON cobranca para o padrao BACEN
      class Bradesco < Pix::Cobrancas::Json::Bacen
        def json
          data = super
          load_txid(data)

          rename_item(data, 'chave', 'chave_pix')
          rename_item(data, 'solicitacaoPagador', 'solicitacaopagador')
          rename_item(data, 'infoAdicionais', 'info_adicionais')

          data
        end

        private

        # Bradesco nao recebe o item loc.id
        def load_json_location(_data)
          nil
        end

        def load_txid(data)
          cob.txid = SecureRandom.hex(35) unless cob.txid
          data['txid'] = cob.txid
        end
      end
    end
  end
end
