# frozen_string_literal: true

require 'pix/version'

require 'pix/cobranca'
require 'pix/cobranca_response'
require 'pix/response_error'

require 'pix/cobrancas/desconto'
require 'pix/cobrancas/info_adicional'

require 'pix/api/credenciais'

# Ruby Pix - Abstração Ruby para API PIX
module Pix
  class Error < StandardError; end
  class ResponseError < StandardError; end

  # @return [String] token do cliente fornecido pelo PSP
  def self.client_id
    @client_id
  end

  # @return [String] token secreto fornecido pelo PSP
  def self.client_secret
    @client_secret
  end

  # @return [String] Ambiente para execucao de chamadas a API
  def self.hambiente
    @hambiente ||= 'producao'
  end

  # Define o ambiente para execucao de chamadas a API
  #   producao | homologacao
  # @return [String]
  def self.hambiente=(value)
    @hambiente = value
  end

  # @return [Boolean]
  def self.producao?
    hambiente == 'producao'
  end

  # Exception lançada quando os dados de cobrança informados estão inválidos.
  #
  # Você pode usar assim na sua aplicação:
  #   rescue Pix::CobrancaInvalida => e
  #   puts e.errors
  class CobrancaInvalida < StandardError
    # Pega os erros de validação
    def initialize(cobranca)
      errors = cobranca.errors.full_messages.join(', ')
      super(errors)
    end
  end
end
