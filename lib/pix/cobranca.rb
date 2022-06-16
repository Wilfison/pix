# frozen_string_literal: true

require_relative './cobrancas/desconto'
require_relative './cobrancas/json'

module Pix
  # Cria class para cobrança (/cob) e cobranças com data fixa (/cobv)
  class Cobranca
    include Cobrancas::Json

    # @return [String] <b>OBRIGATORIO</b>: Chave PIX do recebedor.
    attr_accessor :chave_pix
    # Informação em formato livre, a ser enviada ao recebedor.
    # Esse texto será preenchido, pelo PSP do pagador, no campo RemittanceInformation.
    # O tamanho do campo está limitado a 140 caracteres.
    # @return [String]
    attr_accessor :solicitacao_pagador

    # @return [Integer] <b>OBRIGATORIO</b>: Tempo de vida da cobrança, especificado em segundos.
    attr_accessor :expiracao
    # @return [Date] <b>OBRIGATORIO</b>: Data de vencimento da cobrança.
    attr_accessor :data_vencimento
    # @return [Integer] <b>OBRIGATORIO</b>: Validade em dias corridos após vencimento.
    attr_accessor :validade_apos_vencimento

    # @return [Integer] <b>OBRIGATORIO</b>: Identificador da localização do payload.
    attr_accessor :loc_id

    # @return [String] <b>OBRIGATORIO</b>: Informações sobre o devedor da cobrança.
    attr_accessor :devedor_nome,
                  :devedor_cep,
                  :devedor_uf,
                  :devedor_cidade,
                  :devedor_logradouro

    # @return [String] Documento do devedor da cobrança.
    attr_reader :devedor_cpf,
                :devedor_cnpj

    # @return [Float] <b>OBRIGATORIO</b>: Valor original da cobrança.
    attr_accessor :valor_original

    # Modalidade da multa.
    #
    #   1 = Valor Fixo
    #   2 = Percentual
    attr_accessor :multa_modalidade
    # Multa do documento em valor absoluto ou percentual
    # conforme multa_modalidade.
    attr_accessor :multa_valor

    # Modalidade de juros
    #
    #   1 = Valor (dias corridos)
    #   2 = Percentual ao dia (dias corridos)
    #   3 = Percentual ao mês (dias corridos)
    #   4 = Percentual ao ano (dias corridos)
    #   5 = Valor (dias úteis)
    #   6 = Percentual ao dia (dias úteis)
    #   7 = Percentual ao mês (dias úteis)
    #   8 = Percentual ao ano (dias úteis)
    attr_accessor :juros_modalidade
    # Juros do documento em valor absoluto ou percentual
    # conforme juros_modalidade.
    attr_accessor :juros_valor

    # Modalidade de abatimentos
    #
    #   1 = Valor Fixo
    #   2 = Percentual
    attr_accessor :abatimento_modalidade
    # Abatimentos ou outras deduções aplicadas ao documento,
    # em valor absoluto ou percentual do valor original do documento.
    attr_accessor :abatimento_valor

    # Modalidade de descontos
    #
    #   1 = Valor Fixo até a(s) data(s) informada(s)
    #   2 = Percentual até a data informada
    #   3 = Valor por antecipação dia corrido
    #   4 = Valor por antecipação dia útil
    #   5 = Percentual por antecipação dia corrido
    #   6 = Percentual por antecipação dia útil
    attr_accessor :desconto_modalidade
    # Abatimentos ou outras deduções aplicadas ao documento,
    # em valor absoluto ou percentual do valor original do documento.
    attr_accessor :desconto_valor
    # Lista de Descontos
    # @return [Array<Pix::Cobrancas::Desconto>]
    attr_accessor :descontos

    def initialize(attrs = {})
      attrs.each { |attr, value| send("#{attr}=", value) }

      yield self if block_given?
    end

    # Adiciona desconto com data fixa
    # @param data [Date] Data limite para o desconto
    # @param valor [Float] Desconto em valor absoluto ou percentual
    def add_desconto_data_fixa(data, valor)
      self.descontos = [] if descontos.nil?

      descontos << Cobrancas::Desconto.new(data, valor)
    end

    def devedor_cpf=(cpf)
      @devedor_cpf = sanitize_documento(cpf)
    end

    def devedor_cnpj=(cnpj)
      @devedor_cnpj = sanitize_documento(cnpj)
    end

    def cobranca_com_vencimento?
      data_vencimento.is_a?(Date)
    end
  end
end
