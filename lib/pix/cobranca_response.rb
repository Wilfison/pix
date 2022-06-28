# frozen_string_literal: true

module Pix
  # Resposta da API do PSP
  class CobrancaResponse < Pix::Cobranca
    # @return [DateTime] Data de Criação
    attr_accessor :data_criacao
    # @return [Integer] Revisão
    attr_accessor :revisao

    # @return [String] Localização do payload
    attr_accessor :location
    # @return [String] Data de Criação do payload
    attr_accessor :location_data_criacao
    # @return [String] Tipo da cobrança [cob || cobv]
    attr_accessor :tipo_cobranca
    # @return [String] Status do registro da cobrança
    #
    # * +ATIVA+: indica que o registro se refere a uma cobrança que foi gerada mas ainda não foi paga nem removida;
    # * +CONCLUIDA+: indica que o registro se refere a uma cobrança que já foi paga e, por conseguinte, não pode acolher outro pagamento;
    # * +REMOVIDO_PELO_USUARIO_RECEBEDOR+: indica que o usuário recebedor solicitou a remoção do registro da cobrança; e
    # * +REMOVIDO_PELO_PSP+: indica que o PSP Recebedor solicitou a remoção do registro da cobrança.
    attr_accessor :status

    # @return [String] Pix Copia e Cola correspondente à cobrança.
    attr_accessor :pix_copia_cola

    # @return [String] Chave DICT do recebedor
    attr_accessor :chave_pix

    # @return [String] Solicitação ao pagador
    attr_accessor :solicitacao_pagador

    def initialize(response_body)
      @response_body = response_body
    end

    private


  end
end
