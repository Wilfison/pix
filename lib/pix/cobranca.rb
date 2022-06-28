# frozen_string_literal: true

require 'date'

require 'pix/helpers'
require 'pix/validations'

require 'pix/cobrancas/desconto'
require 'pix/cobrancas/validation'

require 'pix/cobrancas/json/bacen'
require 'pix/cobrancas/json/bradesco'

module Pix
  # Cria class para cobrança (/cob) e cobranças com data fixa (/cobv)
  #
  # {include:Cobrancas::Json}
  #
  # {include:Cobrancas::Validation}
  class Cobranca
    include Helpers
    include Validations
    include Cobrancas::Validation

    # @return [String] Id da Transação
    attr_accessor :txid
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

    # @return [String<Number>] Documento do devedor da cobrança.
    attr_reader :devedor_cpf, :devedor_cnpj

    # @return [Float] <b>OBRIGATORIO</b>: Valor original da cobrança.
    attr_accessor :valor_original

    # Modalidade da multa.
    #
    #   1 = Valor Fixo
    #   2 = Percentual
    # @return [String]
    attr_accessor :multa_modalidade
    # Multa do documento em valor absoluto ou percentual
    # conforme multa_modalidade.
    # @return [Float]
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
    # @return [String]
    attr_accessor :juros_modalidade
    # Juros do documento em valor absoluto ou percentual
    # conforme juros_modalidade.
    # @return [Float]
    attr_accessor :juros_valor

    # Modalidade de abatimentos
    #
    #   1 = Valor Fixo
    #   2 = Percentual
    # @return [String]
    attr_accessor :abatimento_modalidade
    # Abatimentos ou outras deduções aplicadas ao documento,
    # em valor absoluto ou percentual do valor original do documento.
    # @return [Float]
    attr_accessor :abatimento_valor

    # Modalidade de descontos
    #
    #   1 = Valor Fixo até a(s) data(s) informada(s)
    #   2 = Percentual até a data informada
    #   3 = Valor por antecipação dia corrido
    #   4 = Valor por antecipação dia útil
    #   5 = Percentual por antecipação dia corrido
    #   6 = Percentual por antecipação dia útil
    # @return [String]
    attr_accessor :desconto_modalidade
    # Abatimentos ou outras deduções aplicadas ao documento,
    # em valor absoluto ou percentual do valor original do documento.
    # @return [Float]
    attr_accessor :desconto_valor
    # Lista de Descontos
    # @return [Array<Pix::Cobrancas::Desconto>]
    attr_accessor :descontos

    # Informações adicionais
    # @return [Array<Pix::CobrancaResponse::InfoAdicional>]
    attr_accessor :info_adicionais

    validates_presence_of :chave_pix,
                          :loc_id,
                          :devedor_nome,
                          :valor_original,
                          message: 'não pode ficar em branco.'

    def initialize(attrs = {})
      attrs.each { |attr, value| send("#{attr}=", value) }

      yield self if block_given?
    end

    # Adiciona desconto com data fixa
    # @param data [Date] Data limite para o desconto
    # @param valor [Float] Desconto em valor absoluto ou percentual de acordo com desconto_modalidade
    def add_desconto_data_fixa(data, valor)
      self.descontos = [] if descontos.nil?

      descontos << Cobrancas::Desconto.new(data, valor)
    end

    # Adiciona informacao adicional
    # @param nome [String] Nome do campo.
    # @param valor [String] Dados do campo.
    def add_info_adicional(nome, valor)
      self.info_adicionais = [] if info_adicionais.nil?

      info_adicionais << Cobrancas::InfoAdicional.new(nome, valor)
    end

    # Define o CPF do devedor
    # @return [String]
    def devedor_cpf=(cpf)
      @devedor_cpf = sanitize_documento(cpf)
    end

    # Define o CNPJ do devedor
    # @return [String]
    def devedor_cnpj=(cnpj)
      @devedor_cnpj = sanitize_documento(cnpj)
    end

    # Verifica se cobranca tem vencimento
    # @return [Boolean]
    def cobranca_com_vencimento?
      data_vencimento.is_a?(Date)
    end

    # @return [Boolean] Verifica se cobrança está válida
    def valid?
      cobranca_com_vencimento? ? add_cobv_validations : add_cob_validations

      super
    end

    # @return [Boolean] Verifica se cobrança está inválida
    def invalid?
      !valid?
    end

    # @return [Boolean] Verifica se o documento do devedor está presente
    def documento_present?
      !devedor_cpf.nil? || !devedor_cnpj.nil?
    end

    # Retorna Hash formatada no padrao Bacen (pag ou pagv)
    # @return [Hash]
    # @param json_class [Pix::Cobranca::Json]
    def json(json_class = Pix::Cobranca::Json::Bacen)
      raise Pix::Error, errors.full_messages if invalid?

      json_service = json_class.new(self)
      json_service.json
    end

    def create!(numero_banco, credenciais)
      raise Pix::Error, errors.full_messages if invalid?

      api_banco = Pix::API::BANCOS[numero_banco].new(credenciais)
      api_body = api_banco.create!(self)

      CobrancaResponse.new(api_body)
    end

    def update!
      raise Pix::Error, errors.full_messages if invalid?
    end

    def destroy!
      nil
    end
  end
end
